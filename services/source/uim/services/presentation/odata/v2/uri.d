/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.odata.v2.uri;

import uim.services;

mixin(ShowModule!());

@safe:

/// Comparison operators of a $filter expression
enum FilterOperator {
  eq,
  ne,
  gt,
  ge,
  lt,
  le,
  contains,
  startswith,
  endswith
}

/// A single $filter condition, e.g. "Price gt 100" or "contains(Name, 'x')".
struct FilterCondition {
  string property;
  FilterOperator operator;
  string value; // literal value (string without quotes, number, true/false, null)
  bool isString; // whether the value was quoted in the source
}

/// A sort field of $orderby, e.g. ("Name", descending).
struct OrderField {
  string property;
  bool descending;
}

/// The parsed representation of an OData V2 request URI.
class ODataUri {
  /// The entity set name, e.g. "Products"
  string entitySet;

  /// The key value of a single-entity request, e.g. "1" for Products(1); null = collection request
  string key;

  /// Whether the key was quoted (string key)
  bool keyIsString;

  /// Whether the request targets the count of the collection ($count)
  bool count;

  /// $filter conditions (combined with AND)
  FilterCondition[] filters;

  /// $select property names
  string[] select;

  /// $expand navigation property names
  string[] expand;

  /// $orderby fields
  OrderField[] orderBy;

  /// $top value (-1 = not set)
  long top = -1;

  /// $skip value (-1 = not set)
  long skip = -1;

  /// $inlinecount=allpages was requested
  bool inlineCount;

  /// $format value, e.g. "json" (empty = not set)
  string format;

  /// Whether this is a single-entity request
  bool isSingleEntity() const {
    return key.length > 0;
  }
}

/// Parses an OData V2 request path and query string, e.g. parseODataUri("Products(1)", "$select=Name")
ODataUri parseODataUri(string path, string queryString = null) {
  auto uri = new ODataUri;

  // path: "Products", "Products(1)", "Products('abc')", "Products/$count"
  string remaining = path.strip;
  if (remaining.startsWith("/")) {
    remaining = remaining[1 .. $];
  }

  auto countIndex = remaining.countUntil("/$count");
  if (countIndex >= 0) {
    uri.count = true;
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

  parseQueryString(uri, queryString);
  return uri;
}

/// Parses only the query string into an existing ODataUri
void parseQueryString(ODataUri uri, string queryString) {
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
        uri.filters = parseFilter(value);
        break;
      case "$select":
        uri.select = value.splitter(',').map!(part => part.strip).array;
        break;
      case "$expand":
        uri.expand = value.splitter(',').map!(part => part.strip).array;
        break;
      case "$orderby":
        uri.orderBy = parseOrderBy(value);
        break;
      case "$top":
        uri.top = value.to!long;
        break;
      case "$skip":
        uri.skip = value.to!long;
        break;
      case "$inlinecount":
        uri.inlineCount = value == "allpages";
        break;
      case "$format":
        uri.format = value;
        break;
      default:
        break;
    }
  }
}

/// Parses a $filter expression into conditions (AND-combined)
FilterCondition[] parseFilter(string expression) {
  FilterCondition[] result;
  foreach (part; expression.split(" and ")) {
    result ~= parseCondition(part.strip);
  }
  return result;
}

private FilterCondition parseCondition(string condition) {
  // function-style operators: contains(Name,'x'), startswith(...), endswith(...)
  foreach (func; ["contains", "startswith", "endswith"]) {
    string prefix = func ~ "(";
    if (condition.startsWith(prefix) && condition.endsWith(")")) {
      string inner = condition[prefix.length .. $ - 1];
      auto commaIndex = inner.countUntil(',');
      auto operator = func == "contains" ? FilterOperator.contains
        : func == "startswith" ? FilterOperator.startswith
        : FilterOperator.endswith;
      string value = inner[commaIndex + 1 .. $].strip;
      return FilterCondition(inner[0 .. commaIndex].strip, operator, unquote(value), isQuoted(value));
    }
  }

  // comparison operators: "Name eq 'x'", "Price gt 100"
  foreach (op; ["eq", "ne", "gt", "ge", "lt", "le"]) {
    auto parts = condition.split(" " ~ op ~ " ");
    if (parts.length == 2) {
      string value = parts[1].strip;
      return FilterCondition(parts[0].strip, toFilterOperator(op), unquote(value), isQuoted(value));
    }
  }

  throw new Exception("Unsupported $filter condition: " ~ condition);
}

private FilterOperator toFilterOperator(string op) {
  switch (op) {
    case "eq": return FilterOperator.eq;
    case "ne": return FilterOperator.ne;
    case "gt": return FilterOperator.gt;
    case "ge": return FilterOperator.ge;
    case "lt": return FilterOperator.lt;
    case "le": return FilterOperator.le;
    default: throw new Exception("Unknown filter operator: " ~ op);
  }
}

private bool isQuoted(string value) {
  return value.length >= 2 && value.startsWith("'") && value.endsWith("'");
}

private string unquote(string value) {
  return isQuoted(value) ? value[1 .. $ - 1].replace("''", "'") : value;
}

/// Parses a $orderby expression, e.g. "Name asc, Price desc"
OrderField[] parseOrderBy(string expression) {
  OrderField[] result;
  foreach (part; expression.splitter(',')) {
    auto tokens = part.strip.split(" ");
    if (tokens.length == 0 || tokens[0].length == 0) {
      continue;
    }
    bool descending = tokens.length > 1 && tokens[1].toLower == "desc";
    result ~= OrderField(tokens[0], descending);
  }
  return result;
}

///
unittest {
  // collection request
  auto collection = parseODataUri("Products");
  assert(collection.entitySet == "Products");
  assert(!collection.isSingleEntity);
  assert(!collection.count);

  // single entity with numeric key
  auto single = parseODataUri("Products(1)");
  assert(single.entitySet == "Products");
  assert(single.key == "1");
  assert(!single.keyIsString);
  assert(single.isSingleEntity);

  // single entity with string key
  auto stringKey = parseODataUri("Categories('Beverages')");
  assert(stringKey.key == "Beverages");
  assert(stringKey.keyIsString);

  // escaped quote in string key
  assert(parseODataUri("Categories('It''s')").key == "It's");

  // $count
  auto count = parseODataUri("Products/$count");
  assert(count.entitySet == "Products");
  assert(count.count);

  // leading slash is tolerated
  assert(parseODataUri("/Products").entitySet == "Products");

  // query options
  auto queried = parseODataUri("Products", "$filter=Price gt 100&$select=Name,Price&$expand=Category&$orderby=Name asc,Price desc&$top=10&$skip=5&$inlinecount=allpages&$format=json");
  assert(queried.filters.length == 1);
  assert(queried.filters[0].property == "Price");
  assert(queried.filters[0].operator == FilterOperator.gt);
  assert(queried.filters[0].value == "100");
  assert(!queried.filters[0].isString);
  assert(queried.select == ["Name", "Price"]);
  assert(queried.expand == ["Category"]);
  assert(queried.orderBy.length == 2);
  assert(queried.orderBy[0] == OrderField("Name", false));
  assert(queried.orderBy[1] == OrderField("Price", true));
  assert(queried.top == 10);
  assert(queried.skip == 5);
  assert(queried.inlineCount);
  assert(queried.format == "json");

  // filter operators
  assert(parseFilter("Name eq 'Milk'")[0].operator == FilterOperator.eq);
  assert(parseFilter("Name eq 'Milk'")[0].value == "Milk");
  assert(parseFilter("Name eq 'Milk'")[0].isString);
  assert(parseFilter("Name ne 'Milk'")[0].operator == FilterOperator.ne);
  assert(parseFilter("Price ge 10")[0].operator == FilterOperator.ge);
  assert(parseFilter("Price lt 10")[0].operator == FilterOperator.lt);
  assert(parseFilter("Price le 10")[0].operator == FilterOperator.le);

  // function-style filters
  auto contains = parseFilter("contains(Name,'ilk')")[0];
  assert(contains.property == "Name");
  assert(contains.operator == FilterOperator.contains);
  assert(contains.value == "ilk");
  assert(parseFilter("startswith(Name,'M')")[0].operator == FilterOperator.startswith);
  assert(parseFilter("endswith(Name,'k')")[0].operator == FilterOperator.endswith);

  // AND-combined filters
  auto combined = parseFilter("Price gt 10 and Name eq 'Milk'");
  assert(combined.length == 2);
  assert(combined[0].property == "Price");
  assert(combined[1].property == "Name");

  // orderby
  assert(parseOrderBy("Name") == [OrderField("Name", false)]);
  assert(parseOrderBy("Name desc") == [OrderField("Name", true)]);
  assert(parseOrderBy("A asc, B desc").length == 2);

  // invalid filter throws
  import std.exception : assertThrown;
  assertThrown(parseFilter("Price ~= 10"));
}
