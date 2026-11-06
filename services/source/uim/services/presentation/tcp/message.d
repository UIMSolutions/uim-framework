/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.tcp.message;

import uim.service;

mixin(ShowModule!());

@safe:

/// The head of a wire-format message.
private struct TcpHead {
  string startLine;
  string[string] headers;
  size_t bodyStart;
  size_t bodyLength;
}

/// Stores a header, replacing any spelling of the same name. Rejects values that would break the wire format.
private void putHeader(ref string[string] headers, string name, string value) {
  if (name.length == 0 || name.canFind(':') || hasWhitespace(name) || value.canFind('\r') || value.canFind('\n')) {
    throw new Exception("Invalid tcp header: " ~ name);
  }
  foreach (key; headers.keys) {
    if (key.toLower == name.toLower) {
      headers.remove(key);
    }
  }
  headers[name] = value;
}

private bool hasWhitespace(string value) {
  return value.canFind(' ') || value.canFind('\t') || value.canFind('\r') || value.canFind('\n');
}

/// Reads the head of a message. Returns false while the head is incomplete, throws if it is invalid.
private bool readHead(string message, out TcpHead head) {
  bool hasLength;
  size_t position;

  while (true) {
    auto end = message.indexOf('\n', position);
    if (end < 0) {
      return false;
    }
    string line = message[position .. end].strip;
    position = end + 1;

    if (line.length == 0) {
      break;
    }
    if (head.startLine.length == 0) {
      head.startLine = line;
      continue;
    }

    auto colonIndex = line.indexOf(':');
    if (colonIndex <= 0) {
      throw new Exception("Invalid tcp header line: " ~ line);
    }
    string name = line[0 .. colonIndex].strip;
    string value = line[colonIndex + 1 .. $].strip;

    if (name.toLower == "content-length") {
      if (hasLength) {
        throw new Exception("Invalid tcp message: duplicate Content-Length");
      }
      hasLength = true;
      head.bodyLength = value.to!size_t;
    }
    putHeader(head.headers, name, value);
  }

  if (head.startLine.length == 0) {
    throw new Exception("Invalid tcp message: empty head");
  }
  if (head.bodyLength > size_t.max - position) {
    throw new Exception("Invalid tcp message: Content-Length too large");
  }
  head.bodyStart = position;
  return true;
}

/// Reads a message that must consist of exactly one complete frame.
private TcpHead readFrame(string message) {
  TcpHead head;
  if (!readHead(message, head)) {
    throw new Exception("Invalid tcp message: incomplete head");
  }
  if (message.length != head.bodyStart + head.bodyLength) {
    throw new Exception("Invalid tcp message: body does not match Content-Length");
  }
  return head;
}

/// Renders a message. Content-Length is always derived from the body.
private string renderFrame(string startLine, const string[string] headers, string body) {
  auto result = appender!string;
  result.put(startLine ~ "\n");
  foreach (name, value; headers) {
    if (name.toLower != "content-length") {
      result.put("%s: %s\n".format(name, value));
    }
  }
  result.put("Content-Length: %s\n\n".format(body.length));
  result.put(body);
  return result.data;
}

/**
 * Returns the byte length of the first message in a stream buffer, 0 while it is incomplete.
 *
 * TCP is a byte stream, so one read can return part of a message or several messages.
 * Slice buffer[0 .. length] and pass it to parse. Throws if the head is invalid, in which
 * case the connection should be closed. Callers should cap the size of their buffer.
 */
size_t tcpFrameLength(string buffer) {
  TcpHead head;
  if (!readHead(buffer, head)) {
    return 0;
  }
  auto length = head.bodyStart + head.bodyLength;
  return buffer.length >= length ? length : 0;
}

/// A request message of the tcp protocol.
/// Wire format: "METHOD path" line, header lines ("Name: Value"), Content-Length, empty line, body.
class TcpRequest : ITcpRequest {
  this(string method = "GET", string path = "/") {
    if (method.length == 0 || path.length == 0 || hasWhitespace(method) || hasWhitespace(path)) {
      throw new Exception("Invalid tcp request line: " ~ method ~ " " ~ path);
    }
    _method = method.toUpper;
    _path = path;
  }

  string method() const {
    return _method;
  }

  string path() const {
    return _path;
  }

  string peer() const {
    return _peer;
  }

  /// Sets the address of the client (fluent interface)
  auto setPeer(string value) {
    _peer = value;
    return this;
  }

  string[string] headers() const {
    return _headers.dup;
  }

  string header(string name) const {
    foreach (key, value; _headers) {
      if (key.toLower == name.toLower) {
        return value;
      }
    }
    return null;
  }

  /// Sets a header (fluent interface)
  auto setHeader(string name, string value) {
    putHeader(_headers, name, value);
    return this;
  }

  string body() const {
    return _body;
  }

  /// Sets the body (fluent interface)
  auto setBody(string value) {
    _body = value;
    return this;
  }

  Json json() const {
    if (_body.length == 0) {
      return Json(null);
    }
    try {
      return parseJsonString(_body);
    } catch (Exception) {
      return Json(null);
    }
  }

  /// The path segments, e.g. "/products/1" -> ["products", "1"]
  string[] segments() const {
    return _path.split("/").filter!(segment => segment.length > 0).array;
  }

  /// Renders the request in the wire format
  override string toString() const {
    return renderFrame(_method ~ " " ~ _path, _headers, _body);
  }

  /// Parses exactly one wire-format message into a request
  static TcpRequest parse(string message) {
    auto head = readFrame(message);

    auto requestLine = head.startLine.split(" ").filter!(part => part.length > 0).array;
    if (requestLine.length != 2) {
      throw new Exception("Invalid tcp request line: " ~ head.startLine);
    }

    auto request = new TcpRequest(requestLine[0], requestLine[1]);
    request._headers = head.headers;
    request._body = message[head.bodyStart .. $];
    return request;
  }

  private string _method;
  private string _path;
  private string _peer;
  private string[string] _headers;
  private string _body;
}

/// A response message of the tcp protocol.
/// Wire format: "STATUS code" line, header lines, Content-Length, empty line, body.
class TcpResponse : ITcpResponse {
  this(int status = 200, string body = null) {
    _status = status;
    _body = body;
  }

  int status() const {
    return _status;
  }

  ITcpResponse status(int value) {
    _status = value;
    return this;
  }

  string[string] headers() const {
    return _headers.dup;
  }

  ITcpResponse header(string name, string value) {
    putHeader(_headers, name, value);
    return this;
  }

  string body() const {
    return _body;
  }

  ITcpResponse body(string value) {
    _body = value;
    return this;
  }

  ITcpResponse json(Json value) {
    putHeader(_headers, "Content-Type", "application/json");
    _body = value.toString;
    return this;
  }

  /// Renders the response in the wire format
  override string toString() const {
    return renderFrame("STATUS %s".format(_status), _headers, _body);
  }

  /// Parses exactly one wire-format message into a response
  static TcpResponse parse(string message) {
    auto head = readFrame(message);

    if (!head.startLine.startsWith("STATUS ")) {
      throw new Exception("Invalid tcp response line: " ~ head.startLine);
    }

    auto response = new TcpResponse(head.startLine["STATUS ".length .. $].strip.to!int);
    response._headers = head.headers;
    response._body = message[head.bodyStart .. $];
    return response;
  }

  /// Creates a Json response, e.g. TcpResponse.jsonResponse(json, 200)
  static TcpResponse jsonResponse(Json value, int status = 200) {
    auto response = new TcpResponse(status);
    response.json(value);
    return response;
  }

  /// Creates an error response with a Json body
  static TcpResponse error(string message, int status = 500) {
    auto error = Json.emptyObject;
    error["error"] = message;
    error["status"] = status;
    return jsonResponse(error, status);
  }

  private int _status;
  private string[string] _headers;
  private string _body;
}

/// Creates a tcp request, e.g. tcpRequest("GET", "/products")
TcpRequest tcpRequest(string method = "GET", string path = "/") {
  return new TcpRequest(method, path);
}

/// Creates a tcp response, e.g. tcpResponse(200, "OK")
TcpResponse tcpResponse(int status = 200, string body = null) {
  return new TcpResponse(status, body);
}

///
unittest {
  import std.exception : assertThrown;

  // request basics
  auto request = new TcpRequest("get", "/products/1");
  assert(request.method == "GET"); // normalized to upper case
  assert(request.path == "/products/1");
  assert(request.segments == ["products", "1"]);
  assert(request.header("missing") is null);
  assert(request.peer is null);
  assert(request.setPeer("127.0.0.1:5000").peer == "127.0.0.1:5000");

  request.setHeader("X-Tenant-Id", "default").setBody(`{"name":"Milk"}`);
  assert(request.header("x-tenant-id") == "default"); // case-insensitive
  assert(request.json["name"].get!string == "Milk");

  // a header has one value, whatever its spelling
  request.setHeader("x-tenant-id", "other");
  assert(request.headers.length == 1);
  assert(request.header("X-Tenant-Id") == "other");
  request.setHeader("X-Tenant-Id", "default");

  // empty and invalid json bodies
  assert(new TcpRequest().json.type == Json.Type.null_);
  assert(new TcpRequest().setBody("not json").json.type == Json.Type.null_);

  // request wire format round trip
  string wire = request.toString;
  assert(wire.canFind("GET /products/1\n"));
  assert(wire.canFind("X-Tenant-Id: default\n"));
  assert(wire.canFind("Content-Length: 15\n\n"));

  auto parsed = TcpRequest.parse(wire);
  assert(parsed.method == "GET");
  assert(parsed.path == "/products/1");
  assert(parsed.header("X-Tenant-Id") == "default");
  assert(parsed.header("Content-Length") == "15");
  assert(parsed.body == `{"name":"Milk"}`);

  // rendering a parsed message does not repeat Content-Length
  assert(parsed.toString.split("Content-Length").length == 2);

  // CRLF line endings, as sent by line-based clients
  auto crlf = TcpRequest.parse("POST /items\r\nContent-Length: 2\r\n\r\nok");
  assert(crlf.method == "POST");
  assert(crlf.body == "ok");

  // the body may contain line breaks and multi-byte characters
  auto multiline = new TcpRequest("POST", "/items").setBody("a\n\nü");
  assert(TcpRequest.parse(multiline.toString).body == "a\n\nü");

  // invalid request messages
  assertThrown(TcpRequest.parse(""));
  assertThrown(TcpRequest.parse("\n"));
  assertThrown(TcpRequest.parse("ONLYMETHOD\n\n"));
  assertThrown(TcpRequest.parse("GET /a b\n\n"));
  assertThrown(TcpRequest.parse("GET /a\nno colon\n\n"));
  assertThrown(TcpRequest.parse("GET /a\nContent-Length: 5\n\nabc")); // truncated body
  assertThrown(TcpRequest.parse("GET /a\n\ntrailing data"));
  assertThrown(TcpRequest.parse("GET /a\nContent-Length: -1\n\n"));
  assertThrown(TcpRequest.parse("GET /a\nContent-Length: x\n\n"));
  assertThrown(TcpRequest.parse("GET /a\nContent-Length: 0\ncontent-length: 3\n\nabc"));

  // values cannot inject lines into the wire format
  assertThrown(new TcpRequest("GET", "/a\nX-Admin: true"));
  assertThrown(new TcpRequest("GET", "/a b"));
  assertThrown(new TcpRequest("", "/a"));
  assertThrown(new TcpRequest().setHeader("X-Info", "a\r\nX-Admin: true"));
  assertThrown(new TcpRequest().setHeader("X:Info", "a"));
  assertThrown(new TcpRequest().setHeader("", "a"));
  assertThrown(new TcpResponse().header("X-Info", "a\nb"));

  // response basics
  auto response = new TcpResponse;
  assert(response.status == 200);
  response.status(404).header("X-Info", "test").body("not found");
  assert(response.status == 404);
  assert(response.headers["X-Info"] == "test");
  assert(response.body == "not found");

  // json response
  auto json = Json.emptyObject;
  json["ok"] = true;
  auto jsonResponse = TcpResponse.jsonResponse(json, 201);
  assert(jsonResponse.status == 201);
  assert(jsonResponse.headers["Content-Type"] == "application/json");
  assert(jsonResponse.body.canFind(`"ok":true`));

  // error response
  auto error = TcpResponse.error("boom", 500);
  assert(error.status == 500);
  assert(error.body.canFind("boom"));

  // response wire format round trip
  auto parsedResponse = TcpResponse.parse(jsonResponse.toString);
  assert(parsedResponse.status == 201);
  assert(parsedResponse.headers["Content-Type"] == "application/json");
  assert(parsedResponse.body.canFind(`"ok":true`));

  // invalid response messages
  assertThrown(TcpResponse.parse(""));
  assertThrown(TcpResponse.parse("WRONG 200\n\n"));
  assertThrown(TcpResponse.parse("STATUS abc\n\n"));

  // stream framing: partial data
  string first = tcpRequest("POST", "/a").setBody("one").toString;
  string second = tcpRequest("POST", "/b").setBody("two").toString;
  assert(tcpFrameLength("") == 0);
  assert(tcpFrameLength("POST /a") == 0);
  foreach (length; 0 .. first.length) {
    assert(tcpFrameLength(first[0 .. length]) == 0);
  }
  assert(tcpFrameLength(first) == first.length);

  // stream framing: two messages in one read
  string buffer = first ~ second;
  auto frameLength = tcpFrameLength(buffer);
  assert(frameLength == first.length);
  assert(TcpRequest.parse(buffer[0 .. frameLength]).body == "one");
  buffer = buffer[frameLength .. $];
  assert(tcpFrameLength(buffer) == second.length);
  assert(TcpRequest.parse(buffer).path == "/b");

  // stream framing: invalid and oversized heads
  assertThrown(tcpFrameLength("GET /a\nbroken\n\n"));
  assertThrown(tcpFrameLength("GET /a\nContent-Length: 18446744073709551615\n\n"));

  // factories
  assert(tcpRequest("post", "/items").method == "POST");
  assert(tcpResponse(204).status == 204);
}
