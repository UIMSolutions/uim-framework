/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.url.query;

import uim.web;

mixin(ShowModule!());

@safe:

/// URL query parameters preserving insertion order, supporting multiple values per key.
class QueryParams {
  /// Sets a parameter, replacing all existing values (fluent interface)
  auto set(string key, string value) {
    if (key !in _values) {
      _order ~= key;
    }
    _values[key] = [value];
    return this;
  }

  /// Adds a value to a parameter, keeping existing values (fluent interface)
  auto add(string key, string value) {
    if (key !in _values) {
      _order ~= key;
      _values[key] = [];
    }
    _values[key] ~= value;
    return this;
  }

  /// Removes a parameter (fluent interface)
  auto remove(string key) {
    _values.remove(key);
    _order = _order.filter!(k => k != key).array;
    return this;
  }

  /// Checks whether a parameter exists
  bool has(string key) const {
    return (key in _values) !is null;
  }

  /// Returns the first value of a parameter
  string get(string key) const {
    auto found = key in _values;
    return found is null || (*found).length == 0 ? null : (*found)[0];
  }

  /// Returns the first value of a parameter or a default value
  string get(string key, string defaultValue) const {
    auto found = get(key);
    return found is null ? defaultValue : found;
  }

  /// Returns all values of a parameter
  string[] getAll(string key) const {
    auto found = key in _values;
    return found is null ? null : (*found).dup;
  }

  /// All parameter keys in insertion order
  string[] keys() const {
    return _order.dup;
  }

  /// Number of parameters
  size_t length() const {
    return _values.length;
  }

  /// Renders the query string (form-encoded, without leading '?')
  override string toString() const {
    auto result = appender!string;
    foreach (key; _order) {
      string encodedKey = formUrlEncode(key);
      foreach (value; _values[key]) {
        if (result.data.length > 0) {
          result.put('&');
        }
        result.put(encodedKey);
        result.put('=');
        result.put(formUrlEncode(value));
      }
    }
    return result.data;
  }

  private string[][string] _values;
  private string[] _order;
}

/// Creates an empty query parameter collection
QueryParams queryParams() {
  return new QueryParams;
}

/// Creates query parameters from an associative array, sorted by key for stable URLs
QueryParams queryParams(string[string] values) {
  auto params = new QueryParams;
  foreach (key; values.keys.sort) {
    params.set(key, values[key]);
  }
  return params;
}

/// Parses a query string (with or without leading '?') into parameters
QueryParams parseQuery(string query) {
  auto params = new QueryParams;
  string input = query.startsWith("?") ? query[1 .. $] : query;
  foreach (pair; input.splitter('&')) {
    if (pair.length == 0) {
      continue;
    }
    auto eqIndex = pair.indexOf('=');
    if (eqIndex < 0) {
      params.add(formUrlDecode(pair), "");
    } else {
      params.add(formUrlDecode(pair[0 .. eqIndex]), formUrlDecode(pair[eqIndex + 1 .. $]));
    }
  }
  return params;
}

/// Renders an associative array as a query string, e.g. queryString(["a": "1"]) -> "a=1"
string queryString(string[string] values) {
  return queryParams(values).toString;
}

///
unittest {
  // builder
  auto params = new QueryParams;
  assert(params.length == 0);

  params.set("page", "1").set("filter", "new");
  assert(params.length == 2);
  assert(params.has("page"));
  assert(!params.has("missing"));
  assert(params.get("page") == "1");
  assert(params.get("missing") is null);
  assert(params.get("missing", "default") == "default");
  assert(params.keys == ["page", "filter"]);
  assert(params.toString == "page=1&filter=new");

  // multiple values
  params.add("tag", "a").add("tag", "b");
  assert(params.getAll("tag") == ["a", "b"]);
  assert(params.get("tag") == "a");
  assert(params.toString == "page=1&filter=new&tag=a&tag=b");

  // set replaces all values
  params.set("tag", "c");
  assert(params.getAll("tag") == ["c"]);

  params.remove("filter");
  assert(!params.has("filter"));

  // encoding
  assert(queryParams(["q": "a b"]).toString == "q=a+b");
  assert(queryParams(["q": "a&b"]).toString == "q=a%26b");
  assert(queryString(["b": "2", "a": "1", "c": "3"]) == "a=1&b=2&c=3");

  // parsing
  auto parsed = parseQuery("page=2&filter=old&tag=x&tag=y");
  assert(parsed.get("page") == "2");
  assert(parsed.getAll("tag") == ["x", "y"]);
  assert(parsed.keys == ["page", "filter", "tag"]);

  auto withQuestionMark = parseQuery("?a=1");
  assert(withQuestionMark.get("a") == "1");

  auto flagOnly = parseQuery("debug");
  assert(flagOnly.has("debug"));
  assert(flagOnly.get("debug") == "");

  assert(parseQuery("").length == 0);
  assert(parseQuery("q=a+b").get("q") == "a b");
  assert(parseQuery("q=a%26b").get("q") == "a&b");

  // round trip
  auto original = queryParams(["name": "Hänschen", "city": "Köln"]);
  assert(parseQuery(original.toString).get("name") == "Hänschen");
  assert(parseQuery(original.toString).get("city") == "Köln");

  // non-ASCII keys are split at the right byte
  assert(parseQuery("ü=1&straße=2").get("ü") == "1");
  assert(parseQuery("ü=1&straße=2").get("straße") == "2");
}
