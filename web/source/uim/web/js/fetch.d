/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.js.fetch;

import uim.web;

mixin(ShowModule!());

@safe:

/// A builder for JavaScript fetch() calls.
class JsFetch {
  this(string url) {
    _url = url;
  }

  /// Sets the HTTP method (fluent interface)
  auto method(string httpMethod) {
    _method = httpMethod.toUpper;
    return this;
  }

  /// Adds a request header (fluent interface)
  auto header(string name, string value) {
    _headers[name] = value;
    return this;
  }

  /// Sets a raw JS body expression (fluent interface)
  auto body(string expression) {
    _body = expression;
    return this;
  }

  /// Sets a JSON body from a string (fluent interface)
  auto jsonBody(string json) {
    _headers["Content-Type"] = "application/json";
    _body = jsString(json);
    return this;
  }

  /// Sets a JSON body from a Json value (fluent interface)
  auto jsonBody(Json json) {
    return jsonBody(json.toString);
  }

  /// Sets the credentials mode: "omit", "same-origin" or "include" (fluent interface)
  auto credentials(string mode) {
    _credentials = mode;
    return this;
  }

  /// Adds a .then() handler with an arrow function body (fluent interface)
  auto then(string body, string parameter = "response") {
    _thens ~= jsArrowBlock([parameter], body);
    return this;
  }

  /// Adds a .then() handler with a raw handler expression (fluent interface)
  auto thenRaw(string handlerExpression) {
    _thens ~= handlerExpression;
    return this;
  }

  /// Adds a handler extracting the JSON body (fluent interface)
  auto thenJson(string body, string parameter = "data") {
    _thens ~= jsArrow(["response"], "response.json()");
    _thens ~= jsArrowBlock([parameter], body);
    return this;
  }

  /// Adds a handler extracting the text body (fluent interface)
  auto thenText(string body, string parameter = "text") {
    _thens ~= jsArrow(["response"], "response.text()");
    _thens ~= jsArrowBlock([parameter], body);
    return this;
  }

  /// Adds a handler rejecting responses outside the 2xx range, which fetch() does not do itself (fluent interface)
  auto ensureOk() {
    _thens ~= jsArrowBlock(["response"],
      "if (!response.ok) { throw new Error('HTTP ' + response.status); } return response;");
    return this;
  }

  /// Adds a .catch() handler with an arrow function body (fluent interface)
  auto catchError(string body, string parameter = "error") {
    _catch = jsArrowBlock([parameter], body);
    return this;
  }

  /// Renders the fetch call, e.g. `fetch('/api', {method: 'GET'}).then(...);`
  override string toString() const {
    string options = renderOptions;
    string result = options.length > 0
      ? "fetch(%s, %s)".format(jsString(_url), options)
      : "fetch(%s)".format(jsString(_url));

    foreach (handler; _thens) {
      result ~= ".then(%s)".format(handler);
    }
    if (_catch.length > 0) {
      result ~= ".catch(%s)".format(_catch);
    }
    return result ~ ";";
  }

  private string renderOptions() const {
    string[] parts;
    if (_method.length > 0) {
      parts ~= "method: %s".format(jsString(_method));
    }
    if (_headers.length > 0) {
      parts ~= "headers: %s".format(jsObject(_headers.dup));
    }
    if (_credentials.length > 0) {
      parts ~= "credentials: %s".format(jsString(_credentials));
    }
    if (_body.length > 0) {
      parts ~= "body: %s".format(_body);
    }
    return parts.length > 0 ? "{%s}".format(parts.join(", ")) : null;
  }

  private string _url;
  private string _method;
  private string[string] _headers;
  private string _credentials;
  private string _body;
  private string[] _thens;
  private string _catch;
}

/// Creates a fetch builder, e.g. jsFetch("/api/users")
JsFetch jsFetch(string url) {
  return new JsFetch(url);
}

/// Simple GET fetch, e.g. fetchGet("/api") -> `fetch('/api');`
string fetchGet(string url) {
  return new JsFetch(url).method("GET").toString;
}

/// POST fetch with a JSON body
string fetchPost(string url, string jsonBody) {
  return new JsFetch(url).method("POST").jsonBody(jsonBody).toString;
}

/// PUT fetch with a JSON body
string fetchPut(string url, string jsonBody) {
  return new JsFetch(url).method("PUT").jsonBody(jsonBody).toString;
}

/// DELETE fetch
string fetchDelete(string url) {
  return new JsFetch(url).method("DELETE").toString;
}

///
unittest {
  // simple calls
  assert(fetchGet("/api") == `fetch('/api', {method: 'GET'});`);
  assert(fetchPost("/api", `{"a":1}`) == `fetch('/api', {method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"a":1}'});`);
  assert(fetchPut("/api/1", `{"a":2}`).canFind(`method: 'PUT'`));
  assert(fetchDelete("/api/1") == `fetch('/api/1', {method: 'DELETE'});`);

  // builder
  auto request = new JsFetch("/api/users")
    .method("post")
    .header("Authorization", "Bearer token")
    .jsonBody(`{"name":"uim"}`)
    .thenJson("render(data);")
    .catchError("showError(error);");

  string rendered = request.toString;
  assert(rendered.canFind(`fetch('/api/users'`) || rendered.canFind(`fetch('/api/users',`));
  assert(rendered.canFind(`method: 'POST'`));
  assert(rendered.canFind(`Authorization: 'Bearer token'`));
  assert(rendered.canFind(`'Content-Type': 'application/json'`));
  assert(rendered.canFind(`.then((response) => response.json())`));
  assert(rendered.canFind(`.then((data) => { render(data); })`));
  assert(rendered.canFind(`.catch((error) => { showError(error); })`));
  assert(rendered.endsWith(";"));

  // fetch without options
  assert(jsFetch("/api").toString == `fetch('/api');`);

  // raw body and handlers
  auto raw = jsFetch("/api")
    .body("JSON.stringify(payload)")
    .then("handle(response);")
    .thenRaw("console.log");
  assert(raw.toString.canFind("body: JSON.stringify(payload)"));
  assert(raw.toString.canFind(".then((response) => { handle(response); })"));
  assert(raw.toString.canFind(".then(console.log)"));

  // Json body
  auto json = Json.emptyObject;
  json["name"] = "uim";
  auto withJson = jsFetch("/api").method("POST").jsonBody(json);
  assert(withJson.toString.canFind(`body: '{"name":"uim"}'`));

  // further options and handlers
  auto advanced = jsFetch("/api").credentials("include").ensureOk.thenText("show(text);");
  assert(advanced.toString.canFind(`{credentials: 'include'}`));
  assert(advanced.toString.canFind(`if (!response.ok)`));
  assert(advanced.toString.canFind(`.then((response) => response.text())`));
  assert(advanced.toString.canFind(`.then((text) => { show(text); })`));
}
