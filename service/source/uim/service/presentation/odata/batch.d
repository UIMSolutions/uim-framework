/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// OData $batch wire format (multipart/mixed, OData 4.0 §11.7): parsing of
/// batch requests and serialization of batch responses. Execution is done
/// by the controller.
module uim.service.presentation.odata.batch;

import std.array : appender;
import uim.service;
import uim.service.ports.services.entitysets : EntitySetException;

mixin(ShowModule!());

@safe:

/// A protocol level request/response used by the controller — for top-level
/// HTTP requests as well as for the operations inside a $batch.
struct ODataHttpRequest {
  string method; /// upper case: GET, POST, PATCH, PUT, DELETE, HEAD
  string path; /// relative to the service root, URL decoded, without query
  string[string] query; /// decoded query options
  string[string] headers; /// lower case names
  string body;
  string contentId; /// Content-ID inside a change set

  string header(string name, string fallback = "") const {
    if (auto v = name.toLower in headers)
      return *v;
    return fallback;
  }
}

/// ditto
struct ODataHttpResponse {
  int status = 200;
  string[string] headers; /// canonical names, e.g. "Content-Type"
  string body;
  string contentId;
}

/// One operation (or a change set of operations) of a batch request.
struct ODataBatchItem {
  bool isChangeSet;
  ODataHttpRequest request; /// if !isChangeSet
  ODataHttpRequest[] changeSet; /// if isChangeSet
}

/// The boundary parameter of a multipart Content-Type ("" if absent).
string multipartBoundary(string contentType) {
  foreach (param; contentType.split(";")[1 .. $]) {
    auto kv = param.strip;
    auto eq = kv.indexOf('=');
    if (eq > 0 && kv[0 .. eq].strip.toLower == "boundary")
      return kv[eq + 1 .. $].strip.strip("\"");
  }
  return "";
}

/// Normalize line endings to "\n".
private string lf(string s) {
  return s.replace("\r\n", "\n");
}

/// Split a multipart body into its raw parts (headers + body, LF line endings).
string[] splitMultipart(string body, string boundary) {
  if (boundary.length == 0)
    throw new EntitySetException(400, "InvalidBatch", "multipart boundary missing");
  auto text = lf(body);
  auto delimiter = "--" ~ boundary;
  string[] parts;
  auto chunks = text.split(delimiter);
  if (chunks.length < 2)
    throw new EntitySetException(400, "InvalidBatch", "No batch parts found for boundary " ~ boundary);
  // chunks[0] is the preamble; a chunk starting with "--" is the epilogue.
  foreach (chunk; chunks[1 .. $]) {
    if (chunk.startsWith("--"))
      break;
    auto part = chunk.startsWith("\n") ? chunk[1 .. $] : chunk;
    if (part.endsWith("\n"))
      part = part[0 .. $ - 1];
    parts ~= part;
  }
  return parts;
}

/// Split "headers\n\nbody" into a lower-case header map and the body.
private string[string] parseHeaders(string block, out string rest) {
  string[string] headers;
  auto sep = block.indexOf("\n\n");
  string head = sep < 0 ? block : block[0 .. sep];
  rest = sep < 0 ? "" : block[sep + 2 .. $];
  foreach (line; head.split("\n")) {
    auto colon = line.indexOf(':');
    if (colon > 0)
      headers[line[0 .. colon].strip.toLower] = line[colon + 1 .. $].strip;
  }
  return headers;
}

/// Parse an application/http part body into a request.
/// resolvePath converts the request target into (path, query).
ODataHttpRequest parseEmbeddedRequest(string text, string contentId,
    scope void delegate(string target, out string path, out string[string] query) @safe resolvePath) {
  auto t = text.stripLeft("\n");
  auto nl = t.indexOf('\n');
  auto requestLine = (nl < 0 ? t : t[0 .. nl]).strip;
  auto rest = nl < 0 ? "" : t[nl + 1 .. $];

  auto words = requestLine.split(" ").filter!(w => w.length > 0).array;
  if (words.length < 2)
    throw new EntitySetException(400, "InvalidBatch", "Invalid request line in batch: " ~ requestLine);

  ODataHttpRequest r;
  r.method = words[0].toUpper;
  r.contentId = contentId;
  string body;
  if (rest.startsWith("\n")) // no headers
    body = rest[1 .. $];
  else
    r.headers = parseHeaders(rest, body);
  r.body = body.stripRight("\n");
  resolvePath(words[1], r.path, r.query);
  return r;
}

/// Parse a multipart/mixed batch body.
ODataBatchItem[] parseBatch(string body, string contentType,
    scope void delegate(string target, out string path, out string[string] query) @safe resolvePath) {
  ODataBatchItem[] items;
  size_t operations;
  foreach (raw; splitMultipart(body, multipartBoundary(contentType))) {
    string partBody;
    auto headers = parseHeaders(raw, partBody);
    auto type = headers.get("content-type", "").toLower;

    if (type.startsWith("multipart/mixed")) {
      ODataBatchItem item;
      item.isChangeSet = true;
      foreach (inner; splitMultipart(partBody, multipartBoundary(headers["content-type"]))) {
        string innerBody;
        auto innerHeaders = parseHeaders(inner, innerBody);
        item.changeSet ~= parseEmbeddedRequest(innerBody, innerHeaders.get("content-id", ""), resolvePath);
        operations++;
      }
      items ~= item;
    } else if (type.startsWith("application/http")) {
      ODataBatchItem item;
      item.request = parseEmbeddedRequest(partBody, headers.get("content-id", ""), resolvePath);
      items ~= item;
      operations++;
    } else {
      throw new EntitySetException(400, "InvalidBatch", "Unsupported batch part content type: " ~ type);
    }
    if (operations > 1000)
      throw new EntitySetException(413, "BatchTooLarge", "A batch must not contain more than 1000 operations");
  }
  return items;
}

private string statusText(int status) {
  switch (status) {
  case 200:
    return "OK";
  case 201:
    return "Created";
  case 204:
    return "No Content";
  case 400:
    return "Bad Request";
  case 401:
    return "Unauthorized";
  case 403:
    return "Forbidden";
  case 404:
    return "Not Found";
  case 405:
    return "Method Not Allowed";
  case 409:
    return "Conflict";
  case 412:
    return "Precondition Failed";
  case 413:
    return "Payload Too Large";
  case 422:
    return "Unprocessable Entity";
  case 501:
    return "Not Implemented";
  default:
    return status >= 500 ? "Internal Server Error" : "Status";
  }
}

private void writeEmbeddedResponse(A)(ref A x, const ODataHttpResponse r) {
  x ~= "Content-Type: application/http\r\nContent-Transfer-Encoding: binary\r\n";
  if (r.contentId.length > 0)
    x ~= "Content-ID: " ~ r.contentId ~ "\r\n";
  x ~= "\r\nHTTP/1.1 " ~ r.status.to!string ~ " " ~ statusText(r.status) ~ "\r\n";
  foreach (name; r.headers.keys.sort)
    x ~= name ~ ": " ~ r.headers[name] ~ "\r\n";
  x ~= "\r\n";
  if (r.body.length > 0)
    x ~= r.body ~ "\r\n";
}

/// One entry of a batch response: a single response or a change set.
struct ODataBatchResult {
  bool isChangeSet;
  ODataHttpResponse response;
  ODataHttpResponse[] changeSet;
}

/// Serialize a multipart/mixed batch response; returns the body, boundary receives the boundary.
string formatBatchResponse(const ODataBatchResult[] results, out string boundary) @trusted {
  import std.uuid : randomUUID;

  boundary = "batchresponse_" ~ randomUUID.toString;
  auto x = appender!string;
  foreach (result; results) {
    x ~= "--" ~ boundary ~ "\r\n";
    if (!result.isChangeSet) {
      writeEmbeddedResponse(x, result.response);
      continue;
    }
    auto cs = "changesetresponse_" ~ randomUUID.toString;
    x ~= "Content-Type: multipart/mixed; boundary=" ~ cs ~ "\r\n\r\n";
    foreach (r; result.changeSet) {
      x ~= "--" ~ cs ~ "\r\n";
      writeEmbeddedResponse(x, r);
    }
    x ~= "--" ~ cs ~ "--\r\n";
  }
  x ~= "--" ~ boundary ~ "--\r\n";
  return x.data;
}

///
unittest {
  mixin(ShowTest!("parseBatch"));

  auto body = "--batch_1\r\n"
    ~ "Content-Type: application/http\r\n"
    ~ "Content-Transfer-Encoding: binary\r\n\r\n"
    ~ "GET Items?$top=2 HTTP/1.1\r\n"
    ~ "Accept: application/json\r\n\r\n\r\n"
    ~ "--batch_1\r\n"
    ~ "Content-Type: multipart/mixed; boundary=changeset_a\r\n\r\n"
    ~ "--changeset_a\r\n"
    ~ "Content-Type: application/http\r\n"
    ~ "Content-ID: 1\r\n\r\n"
    ~ "POST Items HTTP/1.1\r\n"
    ~ "Content-Type: application/json\r\n\r\n"
    ~ `{"name":"x"}` ~ "\r\n"
    ~ "--changeset_a--\r\n"
    ~ "--batch_1--\r\n";

  void resolve(string target, out string path, out string[string] query) @safe {
    auto q = target.indexOf('?');
    path = q < 0 ? target : target[0 .. q];
    if (q >= 0)
      query["raw"] = target[q + 1 .. $];
  }

  auto items = parseBatch(body, "multipart/mixed; boundary=batch_1", &resolve);
  assert(items.length == 2);
  assert(!items[0].isChangeSet && items[0].request.method == "GET" && items[0].request.path == "Items");
  assert(items[0].request.query["raw"] == "$top=2");
  assert(items[0].request.header("Accept") == "application/json");
  assert(items[1].isChangeSet && items[1].changeSet.length == 1);
  assert(items[1].changeSet[0].method == "POST" && items[1].changeSet[0].contentId == "1");
  assert(items[1].changeSet[0].body == `{"name":"x"}`);

  ODataHttpResponse ok;
  ok.body = "{}";
  ok.headers["Content-Type"] = "application/json";
  ODataHttpResponse created;
  created.status = 201;
  created.contentId = "1";
  string boundary;
  auto text = formatBatchResponse([ODataBatchResult(false, ok), ODataBatchResult(true, ODataHttpResponse.init, [created])],
    boundary);
  assert(text.canFind("HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{}"));
  assert(text.canFind("Content-ID: 1\r\n\r\nHTTP/1.1 201 Created"));
  assert(text.endsWith("--" ~ boundary ~ "--\r\n"));
  assert(multipartBoundary(`multipart/mixed; boundary="b 1"`) == "b 1");
}
