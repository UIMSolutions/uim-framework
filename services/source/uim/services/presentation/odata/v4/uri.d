/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.odata.v4.uri;

import uim.services;

mixin(ShowModule!());

@safe:

/// Comparison operators of a V4 $filter expression
enum V4FilterOperator {
  eq,
  ne,
  gt,
  ge,
  lt,
  le,
  in_,
  contains,
  startswith,
  endswith
}

/// A single V4 $filter condition.
struct V4FilterCondition {
  string property;
  V4FilterOperator operator;
  string value; // literal value (string without quotes, number, true/false, null)
  bool isString; // whether the value was quoted in the source
  string[] inValues; // values of an "in" condition
}

/// A sort field of $orderby, e.g. ("Name", descending).
struct V4OrderField {
  string property;
  bool descending;
}

/// The parsed representation of an OData V4 request URI.
class ODataV4Uri {
  /// The entity set name, e.g. "Products"
  string entitySet;

  /// The key value of a single-entity request, e.g. "1" for Products(1); null = collection request
  string key;

  /// Whether the key was quoted (string key)
  bool keyIsString;

  /// Whether the request targets the count of the collection ($count segment)
  bool countSegment;

  /// $filter conditions (combined with AND)
  V4FilterCondition[] filters;

  /// $select property names
  string[] select;

  /// $expand navigation property names
  string[] expand;

  /// $orderby fields
  V4OrderField[] orderBy;

  /// $top value (-1 = not set)
  long top = -1;

  /// $skip value (-1 = not set)
  long skip = -1;

  /// $count=true was requested (inline count in the response)
  bool count;

  /// $search term (empty = not set)
  string search;

  /// $format value, e.g. "json" (empty = not set)
  string format;

  /// Whether this is a single-entity request
  bool isSingleEntity() const {
    return key.length > 0;
  }
}

/// Parses an OData V4 request path and query string, e.g. parseODataV4Uri("Products(1)", "$select=Name")
ODataV4Uri parseODataV4Uri(string path, string queryString = null) {
  auto uri = new ODataV4Uri;

  string remaining = path.strip;
  if (remaining.startsWith("/")) {
    remaining = remaining[1 .. $];
  }

  auto countIndex = remaining.countUntil("/$count");
  if (countIndex >= 0) {
    uri.countSegment = true;
    remaining = remaining[0 .. countIndex];
  }

  auto parenIndex = remaining.countUntil('(');
  if (parenIndex >= 0 && remaining.endsWith(")")) {
    uri.entitySet = remaining[0 .. parenIndex];
    string keyPart = remaining[parenIndex + 1 .. $ - 1].strip;
    if (keyPart.length >= 2 && keyPart.startsWith("'") && keyPart.endsWith("'")) {
      uri.key = keyPart[1 .. $ - 1].replace("''", "'");
      uri.keyIsString = true;
    } else {
      uri.key = keyPart;
    }
  } else {
    uri.entitySet = remaining;
  }

  parseV4QueryString(uri, queryString);
  return uri;
}

/// Parses only the query string into an existing ODataV4Uri
void parseV4QueryString(ODataV4Uri uri, string queryString) {
  if (queryString.length == 0) {
    return;
  }
  string input = queryString.startsWith("?") ? queryString[1 .. $] : queryString;
  foreach (pair; input.splitter('&')) {
    auto eqIndex = pair.countUntil('=');
    if (eqIndex <= 0) {
      continue;
    }
    string name = pair[0 .. eqIndex];
    string value = pair[eqIndex + 1 .. $];
    switch (name) {
      case "$filter":
        uri.filters = parseV4Filter(value);
        break;
      case "$select":
        uri.select = value.splitter(',').map!(part => part.strip).array;
        break;
      case "$expand":
        uri.expand = value.splitter(',').map!(part => part.strip).array;
        break;
      case "$orderby":
        uri.orderBy = parseV4OrderBy(value);
        break;
      case "$top":
        uri.top = value.to!long;
        break;
      case "$skip":
        uri.skip = value.to!long;
        break;
      case "$count":
        uri.count = value.toLower == "true";
        break;
      case "$search":
        uri.search = value;
        break;
      case "$format":
        uri.format = value;
        break;
      default:
        break;
    }
  }
}

/// Parses a V4 $filter expression into conditions (AND-combined)
V4FilterCondition[] parseV4Filter(string expression) {
  V4FilterCondition[] result;
  foreach (part; expression.split(" and ")) {
    result ~= parseV4Condition(part.strip);
  }
  return result;
}

private V4FilterCondition parseV4Condition(string condition) {
  // function-style operators: contains(Name,'x'), startswith(...), endswith(...)
  foreach (func; ["contains", "startswith", "endswith"]) {
    string prefix = func ~ "(";
    if (condition.startsWith(prefix) && condition.endsWith(")")) {
      string inner = condition[prefix.length .. $ - 1];
      auto commaIndex = inner.countUntil(',');
      auto operator = func == "contains" ? V4FilterOperator.contains
        : func == "startswith" ? V4FilterOperator.startswith
        : V4FilterOperator.endswith;
      string value = inner[commaIndex + 1 .. $].strip;
      return V4FilterCondition(inner[0 .. commaIndex].strip, operator, unquoteV4(value), isQuotedV4(value));
    }
  }

  // "in" operator: "Name in ('Milk', 'Bread')"
  auto inParts = condition.split(" in ");
  if (inParts.length == 2 && inParts[1].strip.startsWith("(") && inParts[1].strip.endsWith(")")) {
    string list = inParts[1].strip[1 .. $ - 1];
    auto values = list.splitter(',')
      .map!(part => unquoteV4(part.strip))
      .array;
    return V4FilterCondition(inParts[0].strip, V4FilterOperator.in_, null, false, values);
  }

  // comparison operators: "Name eq 'x'", "Price gt 100"
  foreach (op; ["eq", "ne", "gt", "ge", "lt", "le"]) {
    auto parts = condition.split(" " ~ op ~ " ");
    if (parts.length == 2) {
      string value = parts[1].strip;
      return V4FilterCondition(parts[0].strip, toV4FilterOperator(op), unquoteV4(value), isQuotedV4(value));
    }
  }

  throw new Exception("Unsupported $filter condition: " ~ condition);
}

private V4FilterOperator toV4FilterOperator(string op) {
  switch (op) {
    case "eq": return V4FilterOperator.eq;
    case "ne": return V4FilterOperator.ne;
    case "gt": return V4FilterOperator.gt;
    case "ge": return V4FilterOperator.ge;
    case "lt": return V4FilterOperator.lt;
    case "le": return V4FilterOperator.le;
    default: throw new Exception("Unknown filter operator: " ~ op);
  }
}

private bool isQuotedV4(string value) {
  return value.length >= 2 && value.startsWith("'") && value.endsWith("'");
}

private string unquoteV4(string value) {
  return isQuotedV4(value) ? value[1 .. $ - 1].replace("''", "'") : value;
}

/// Parses a $orderby expression, e.g. "Name asc, Price desc"
V4OrderField[] parseV4OrderBy(string expression) {
  V4OrderField[] result;
  foreach (part; expression.splitter(',')) {
    auto tokens = part.strip.split(" ");
    if (tokens.length == 0 || tokens[0].length == 0) {
      continue;
    }
    bool descending = tokens.length > 1 && tokens[1].toLower == "desc";
    result ~= V4OrderField(tokens[0], descending);
  }
  return result;
}

///
unittest {
  // collection request
  auto collection = parseODataV4Uri("Products");
  assert(collection.entitySet == "Products");
  assert(!collection.isSingleEntity);
  assert(!collection.countSegment);

  // single entity with numeric key
  auto single = parseODataV4Uri("Products(1)");
  assert(single.key == "1");
  assert(!single.keyIsString);
  assert(single.isSingleEntity);

  // string key with escaping
  auto stringKey = parseODataV4Uri("Categories('It''s')");
  assert(stringKey.key == "It's");
  assert(stringKey.keyIsString);

  // $count segment
  auto count = parseODataV4Uri("Products/$count");
  assert(count.countSegment);
  assert(count.entitySet == "Products");

  // query options
  auto queried = parseODataV4Uri("Products",
    "$filter=Price gt 100&$select=Name,Price&$expand=Category&$orderby=Name desc&$top=10&$skip=5&$count=true&$search=milk&$format=json");
  assert(queried.filters.length == 1);
  assert(queried.filters[0].operator == V4FilterOperator.gt);
  assert(queried.select == ["Name", "Price"]);
  assert(queried.expand == ["Category"]);
  assert(queried.orderBy == [V4OrderField("Name", true)]);
  assert(queried.top == 10);
  assert(queried.skip == 5);
  assert(queried.count);
  assert(queried.search == "milk");
  assert(queried.format == "json");

  // $count=false
  assert(!parseODataV4Uri("Products", "$count=false").count);

  // filter operators
  assert(parseV4Filter("Name eq 'Milk'")[0].operator == V4FilterOperator.eq);
  assert(parseV4Filter("Name eq 'Milk'")[0].value == "Milk");
  assert(parseV4Filter("Name eq 'Milk'")[0].isString);
  assert(parseV4Filter("Price ne 5")[0].operator == V4FilterOperator.ne);
  assert(parseV4Filter("Price ge 5")[0].operator == V4FilterOperator.ge);
  assert(parseV4Filter("Price lt 5")[0].operator == V4FilterOperator.lt);
  assert(parseV4Filter("Price le 5")[0].operator == V4FilterOperator.le);

  // V4 "in" operator
  auto inCondition = parseV4Filter("Name in ('Milk', 'Bread')")[0];
  assert(inCondition.operator == V4FilterOperator.in_);
  assert(inCondition.property == "Name");
  assert(inCondition.inValues == ["Milk", "Bread"]);

  // function-style filters
  assert(parseV4Filter("contains(Name,'ilk')")[0].operator == V4FilterOperator.contains);
  assert(parseV4Filter("startswith(Name,'M')")[0].operator == V4FilterOperator.startswith);
  assert(parseV4Filter("endswith(Name,'k')")[0].operator == V4FilterOperator.endswith);

  // AND-combined filters
  assert(parseV4Filter("Price gt 10 and Name eq 'Milk'").length == 2);

  // orderby
  assert(parseV4OrderBy("Name") == [V4OrderField("Name", false)]);
  assert(parseV4OrderBy("A asc, B desc").length == 2);

  // invalid filter throws
  import std.exception : assertThrown;
  assertThrown(parseV4Filter("Price ~= 10"));
}
