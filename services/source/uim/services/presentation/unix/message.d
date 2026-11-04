/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.unix.message;

import uim.services;
import uim.services.presentation.unix.interfaces;

mixin(ShowModule!());

@safe:

/// A request message of the unix socket protocol.
/// Wire format: "METHOD path" line, header lines ("Name: Value"), empty line, body.
class UnixRequest : IUnixRequest {
  this(string method = "GET", string path = "/") {
    _method = method.toUpper;
    _path = path;
  }

  string method() const {
    return _method;
  }

  string path() const {
    return _path;
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
    _headers[name] = value;
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

  // @trusted: Json parsing is memory-safe here
  @trusted Json json() const {
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
    auto result = appender!string;
    result.put(_method ~ " " ~ _path ~ "\n");
    foreach (name, value; _headers) {
      result.put("%s: %s\n".format(name, value));
    }
    result.put("\n");
    result.put(_body);
    return result.data;
  }

  /// Parses a wire-format message into a request
  static UnixRequest parse(string message) {
    auto lines = message.split("\n");
    if (lines.length == 0 || lines[0].strip.length == 0) {
      throw new Exception("Invalid unix request: empty message");
    }

    auto requestLine = lines[0].strip.split(" ");
    if (requestLine.length < 2) {
      throw new Exception("Invalid unix request line: " ~ lines[0]);
    }
    auto request = new UnixRequest(requestLine[0], requestLine[1]);

    size_t i = 1;
    for (; i < lines.length; i++) {
      string line = lines[i].strip;
      if (line.length == 0) {
        i++;
        break;
      }
      auto colonIndex = line.countUntil(':');
      if (colonIndex > 0) {
        request.setHeader(line[0 .. colonIndex].strip, line[colonIndex + 1 .. $].strip);
      }
    }
    request.setBody(lines[i .. $].join("\n"));
    return request;
  }

  private string _method;
  private string _path;
  private string[string] _headers;
  private string _body;
}

/// A response message of the unix socket protocol.
/// Wire format: "STATUS code" line, header lines, empty line, body.
class UnixResponse : IUnixResponse {
  this(int status = 200, string body = null) {
    _status = status;
    _body = body;
  }

  int status() const {
    return _status;
  }

  IUnixResponse status(int value) {
    _status = value;
    return this;
  }

  string[string] headers() const {
    return _headers.dup;
  }

  IUnixResponse header(string name, string value) {
    _headers[name] = value;
    return this;
  }

  string body() const {
    return _body;
  }

  IUnixResponse body(string value) {
    _body = value;
    return this;
  }

  // @trusted: Json serialization is memory-safe here
  @trusted IUnixResponse json(Json value) {
    _headers["Content-Type"] = "application/json";
    _body = value.toString;
    return this;
  }

  /// Renders the response in the wire format
  override string toString() const {
    auto result = appender!string;
    result.put("STATUS %s\n".format(_status));
    foreach (name, value; _headers) {
      result.put("%s: %s\n".format(name, value));
    }
    result.put("\n");
    result.put(_body);
    return result.data;
  }

  /// Parses a wire-format message into a response
  static UnixResponse parse(string message) {
    auto lines = message.split("\n");
    if (lines.length == 0 || !lines[0].strip.startsWith("STATUS ")) {
      throw new Exception("Invalid unix response: " ~ (lines.length > 0 ? lines[0] : "empty message"));
    }

    auto response = new UnixResponse(lines[0].strip["STATUS ".length .. $].to!int);

    size_t i = 1;
    for (; i < lines.length; i++) {
      string line = lines[i].strip;
      if (line.length == 0) {
        i++;
        break;
      }
      auto colonIndex = line.countUntil(':');
      if (colonIndex > 0) {
        response.header(line[0 .. colonIndex].strip, line[colonIndex + 1 .. $].strip);
      }
    }
    response.body(lines[i .. $].join("\n"));
    return response;
  }

  /// Creates a Json response, e.g. unixJsonResponse(json, 200)
  static UnixResponse jsonResponse(Json value, int status = 200) {
    auto response = new UnixResponse(status);
    response.json(value);
    return response;
  }

  /// Creates an error response with a Json body
  static UnixResponse error(string message, int status = 500) {
    auto error = Json.emptyObject;
    error["error"] = message;
    error["status"] = status;
    return jsonResponse(error, status);
  }

  private int _status;
  private string[string] _headers;
  private string _body;
}

/// Creates a unix request, e.g. unixRequest("GET", "/products")
UnixRequest unixRequest(string method = "GET", string path = "/") {
  return new UnixRequest(method, path);
}

/// Creates a unix response, e.g. unixResponse(200, "OK")
UnixResponse unixResponse(int status = 200, string body = null) {
  return new UnixResponse(status, body);
}

///
unittest {
  // request basics
  auto request = new UnixRequest("get", "/products/1");
  assert(request.method == "GET"); // normalized to upper case
  assert(request.path == "/products/1");
  assert(request.segments == ["products", "1"]);
  assert(request.header("missing") is null);

  request.setHeader("X-Tenant-Id", "default").setBody(`{"name":"Milk"}`);
  assert(request.header("x-tenant-id") == "default"); // case-insensitive
  assert(request.json["name"].get!string == "Milk");

  // empty and invalid json bodies
  assert(new UnixRequest().json.type == Json.Type.null_);
  assert(new UnixRequest().setBody("not json").json.type == Json.Type.null_);

  // request wire format round trip
  string wire = request.toString;
  assert(wire.canFind("GET /products/1\n"));
  assert(wire.canFind("X-Tenant-Id: default\n"));

  auto parsed = UnixRequest.parse(wire);
  assert(parsed.method == "GET");
  assert(parsed.path == "/products/1");
  assert(parsed.header("X-Tenant-Id") == "default");
  assert(parsed.body == `{"name":"Milk"}`);

  // invalid request messages
  import std.exception : assertThrown;
  assertThrown(UnixRequest.parse(""));
  assertThrown(UnixRequest.parse("ONLYMETHOD\n"));

  // response basics
  auto response = new UnixResponse;
  assert(response.status == 200);
  response.status(404).header("X-Info", "test").body("not found");
  assert(response.status == 404);
  assert(response.headers["X-Info"] == "test");
  assert(response.body == "not found");

  // json response
  auto json = Json.emptyObject;
  json["ok"] = true;
  auto jsonResponse = UnixResponse.jsonResponse(json, 201);
  assert(jsonResponse.status == 201);
  assert(jsonResponse.headers["Content-Type"] == "application/json");
  assert(jsonResponse.body.canFind(`"ok":true`));

  // error response
  auto error = UnixResponse.error("boom", 500);
  assert(error.status == 500);
  assert(error.body.canFind("boom"));

  // response wire format round trip
  auto parsedResponse = UnixResponse.parse(jsonResponse.toString);
  assert(parsedResponse.status == 201);
  assert(parsedResponse.headers["Content-Type"] == "application/json");
  assert(parsedResponse.body.canFind(`"ok":true`));

  // invalid response messages
  assertThrown(UnixResponse.parse(""));
  assertThrown(UnixResponse.parse("WRONG 200\n"));

  // factories
  assert(unixRequest("post", "/items").method == "POST");
  assert(unixResponse(204).status == 204);
}
