/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// OData v4 system query options evaluated in memory over JSON rows:
/// $filter, $orderby, $select, $top, $skip, $skiptoken, $count, $search.
///
/// Supported $filter grammar:
///   comparison  eq ne gt ge lt le, `in` with a list: status in ('a','b')
///   logical     and or not, grouping ( )
///   functions   contains startswith endswith (bool)
///               tolower toupper trim concat substring (string)
///               length indexof year month day hour minute second (number)
///   literals    'string' ('' escapes a quote), integers, decimals,
///               true false null, unquoted date/time values
///               (2026-11-09, 2026-11-09T10:00:00Z) compared as ISO strings
module uim.service.presentation.odata.query;

import std.ascii : isAlphaNum, isDigit, isWhite;
import std.uni : toLower, toUpper;
import uim.service;

mixin(ShowModule!());

@safe:

/// Invalid query option — reported to the client as HTTP 400.
class ODataQueryException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow {
    super(msg, file, line);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter AST
// ─────────────────────────────────────────────────────────────────────────────

abstract class ODataFilterNode {
  abstract Json evaluate(Json row) const;
}

class ODataLiteralNode : ODataFilterNode {
  Json value;
  this(Json value) {
    this.value = value;
  }

  override Json evaluate(Json row) const {
    return value.clone;
  }
}

class ODataPropertyNode : ODataFilterNode {
  string name;
  this(string name) {
    this.name = name;
  }

  override Json evaluate(Json row) const {
    if (row.type != Json.Type.object)
      return Json(null);
    if (auto v = name in row)
      return *v;
    return Json(null);
  }
}

class ODataNotNode : ODataFilterNode {
  ODataFilterNode operand;
  this(ODataFilterNode operand) {
    this.operand = operand;
  }

  override Json evaluate(Json row) const {
    return Json(!odataTruthy(operand.evaluate(row)));
  }
}

class ODataInNode : ODataFilterNode {
  ODataFilterNode operand;
  ODataFilterNode[] candidates;
  this(ODataFilterNode operand, ODataFilterNode[] candidates) {
    this.operand = operand;
    this.candidates = candidates;
  }

  override Json evaluate(Json row) const {
    auto v = operand.evaluate(row);
    foreach (c; candidates)
      if (odataEquals(v, c.evaluate(row)))
        return Json(true);
    return Json(false);
  }
}

class ODataBinaryNode : ODataFilterNode {
  string op;
  ODataFilterNode left, right;
  this(string op, ODataFilterNode left, ODataFilterNode right) {
    this.op = op;
    this.left = left;
    this.right = right;
  }

  override Json evaluate(Json row) const {
    if (op == "and")
      return Json(odataTruthy(left.evaluate(row)) && odataTruthy(right.evaluate(row)));
    if (op == "or")
      return Json(odataTruthy(left.evaluate(row)) || odataTruthy(right.evaluate(row)));

    auto l = left.evaluate(row);
    auto r = right.evaluate(row);
    if (op == "eq")
      return Json(odataEquals(l, r));
    if (op == "ne")
      return Json(!odataEquals(l, r));

    int c;
    if (!odataCompare(l, r, c))
      return Json(false);
    switch (op) {
    case "gt":
      return Json(c > 0);
    case "ge":
      return Json(c >= 0);
    case "lt":
      return Json(c < 0);
    case "le":
      return Json(c <= 0);
    default:
      return Json(false);
    }
  }
}

class ODataFunctionNode : ODataFilterNode {
  string name;
  ODataFilterNode[] args;
  this(string name, ODataFilterNode[] args) {
    this.name = name;
    this.args = args;
  }

  override Json evaluate(Json row) const {
    string str(size_t i) {
      auto v = args[i].evaluate(row);
      return v.type == Json.Type.string ? v.get!string : (v.type == Json.Type.null_ || v.type == Json.Type.undefined ? ""
          : v.toString);
    }

    long num(size_t i) {
      auto v = args[i].evaluate(row);
      if (v.type == Json.Type.int_)
        return v.get!long;
      if (v.type == Json.Type.float_)
        return cast(long) v.get!double;
      throw new ODataQueryException("Function '" ~ name ~ "' expects a number as argument " ~ (i + 1).to!string);
    }

    /// Date/time part of an ISO 8601 string: 2026-11-09T10:20:30Z
    Json datePart(size_t from, size_t to) {
      auto s = str(0);
      if (s.length < to)
        return Json(null);
      try
        return Json(s[from .. to].to!long);
      catch (Exception)
        return Json(null);
    }

    switch (name) {
    case "contains":
      return Json(str(0).toLower.canFind(str(1).toLower));
    case "startswith":
      return Json(str(0).startsWith(str(1)));
    case "endswith":
      return Json(str(0).endsWith(str(1)));
    case "tolower":
      return Json(str(0).toLower);
    case "toupper":
      return Json(str(0).toUpper);
    case "trim":
      return Json(str(0).strip);
    case "concat":
      return Json(str(0) ~ str(1));
    case "length":
      return Json(cast(long) str(0).length);
    case "indexof":
      return Json(cast(long) str(0).indexOf(str(1)));
    case "substring":
      auto s = str(0);
      auto start = num(1);
      if (start < 0 || start > s.length)
        return Json("");
      auto end = args.length > 2 ? min(s.length, start + max(0, num(2))) : s.length;
      return Json(s[cast(size_t) start .. cast(size_t) end]);
    case "year":
      return datePart(0, 4);
    case "month":
      return datePart(5, 7);
    case "day":
      return datePart(8, 10);
    case "hour":
      return datePart(11, 13);
    case "minute":
      return datePart(14, 16);
    case "second":
      return datePart(17, 19);
    default:
      return Json(null);
    }
  }
}

/// name → [min, max] arguments
private immutable size_t[2][string] functionArity;

shared static this() {
  functionArity = [
    "contains": [2, 2], "startswith": [2, 2], "endswith": [2, 2],
    "tolower": [1, 1], "toupper": [1, 1], "trim": [1, 1], "concat": [2, 2],
    "length": [1, 1], "indexof": [2, 2], "substring": [2, 3],
    "year": [1, 1], "month": [1, 1], "day": [1, 1],
    "hour": [1, 1], "minute": [1, 1], "second": [1, 1],
  ];
}

bool odataTruthy(Json v) {
  return v.type == Json.Type.bool_ && v.get!bool;
}

private bool isNumber(Json v) {
  return v.type == Json.Type.int_ || v.type == Json.Type.float_;
}

private bool isNullish(Json v) {
  return v.type == Json.Type.null_ || v.type == Json.Type.undefined;
}

private double asDouble(Json v) {
  return v.type == Json.Type.int_ ? cast(double) v.get!long : v.get!double;
}

/// OData equality: null eq null is true; otherwise values must be comparable and equal.
bool odataEquals(Json a, Json b) {
  if (isNullish(a) || isNullish(b))
    return isNullish(a) && isNullish(b);
  int c;
  return odataCompare(a, b, c) && c == 0;
}

/// Three-way comparison; returns false if the values are not comparable.
bool odataCompare(Json a, Json b, out int result) {
  if (isNumber(a) && isNumber(b)) {
    auto x = asDouble(a), y = asDouble(b);
    result = x < y ? -1 : (x > y ? 1 : 0);
    return true;
  }
  if (a.type == Json.Type.string && b.type == Json.Type.string) {
    result = cmp(a.get!string, b.get!string);
    return true;
  }
  if (a.type == Json.Type.bool_ && b.type == Json.Type.bool_) {
    result = cast(int) a.get!bool - cast(int) b.get!bool;
    return true;
  }
  // numbers compared with numeric strings (Int64/Decimal as IEEE754Compatible strings)
  if (isNumber(a) && b.type == Json.Type.string || a.type == Json.Type.string && isNumber(b)) {
    try {
      auto x = isNumber(a) ? asDouble(a) : a.get!string.to!double;
      auto y = isNumber(b) ? asDouble(b) : b.get!string.to!double;
      result = x < y ? -1 : (x > y ? 1 : 0);
      return true;
    } catch (Exception) {
      return false;
    }
  }
  return false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter parser (recursive descent)
// ─────────────────────────────────────────────────────────────────────────────

private struct Token {
  enum Kind {
    word,
    str,
    open,
    close,
    comma,
    end
  }

  Kind kind;
  string text;
}

private bool isWordChar(char c) {
  return isAlphaNum(c) || c == '_' || c == '-' || c == '.' || c == ':' || c == '+' || c == '/';
}

private Token[] tokenize(string input) {
  Token[] tokens;
  size_t i = 0;
  while (i < input.length) {
    auto c = input[i];
    if (isWhite(c)) {
      i++;
      continue;
    }
    if (c == '(') {
      tokens ~= Token(Token.Kind.open, "(");
      i++;
    } else if (c == ')') {
      tokens ~= Token(Token.Kind.close, ")");
      i++;
    } else if (c == ',') {
      tokens ~= Token(Token.Kind.comma, ",");
      i++;
    } else if (c == '\'') {
      string value;
      i++;
      bool closed;
      while (i < input.length) {
        if (input[i] == '\'') {
          if (i + 1 < input.length && input[i + 1] == '\'') {
            value ~= '\'';
            i += 2;
            continue;
          }
          closed = true;
          i++;
          break;
        }
        value ~= input[i];
        i++;
      }
      if (!closed)
        throw new ODataQueryException("Unterminated string literal in $filter");
      tokens ~= Token(Token.Kind.str, value);
    } else if (isWordChar(c)) {
      auto start = i;
      while (i < input.length && isWordChar(input[i]))
        i++;
      tokens ~= Token(Token.Kind.word, input[start .. i]);
    } else {
      throw new ODataQueryException("Unexpected character '" ~ c ~ "' in $filter");
    }
  }
  tokens ~= Token(Token.Kind.end, "");
  return tokens;
}

private struct FilterParser {
  Token[] tokens;
  size_t pos;
  const(string)[] properties;
  size_t depth;

  Token peek() {
    return tokens[pos];
  }

  Token next() {
    return tokens[pos++];
  }

  bool isKeyword(string word) {
    return peek().kind == Token.Kind.word && peek().text == word;
  }

  void expect(Token.Kind kind, string what) {
    if (peek().kind != kind)
      throw new ODataQueryException("Expected " ~ what ~ " in $filter near '" ~ peek().text ~ "'");
    pos++;
  }

  void enter() {
    // guards the recursive descent against pathological nesting
    if (++depth > 64)
      throw new ODataQueryException("$filter is nested too deeply");
  }

  ODataFilterNode parse() {
    auto node = parseOr();
    if (peek().kind != Token.Kind.end)
      throw new ODataQueryException("Unexpected '" ~ peek().text ~ "' in $filter");
    return node;
  }

  ODataFilterNode parseOr() {
    enter();
    scope (exit)
      depth--;
    auto left = parseAnd();
    while (isKeyword("or")) {
      next();
      left = new ODataBinaryNode("or", left, parseAnd());
    }
    return left;
  }

  ODataFilterNode parseAnd() {
    auto left = parseNot();
    while (isKeyword("and")) {
      next();
      left = new ODataBinaryNode("and", left, parseNot());
    }
    return left;
  }

  ODataFilterNode parseNot() {
    if (isKeyword("not")) {
      next();
      enter();
      scope (exit)
        depth--;
      return new ODataNotNode(parseNot());
    }
    return parseComparison();
  }

  ODataFilterNode parseComparison() {
    auto left = parseOperand();
    if (peek().kind == Token.Kind.word && ["eq", "ne", "gt", "ge", "lt", "le"].canFind(peek().text)) {
      auto op = next().text;
      return new ODataBinaryNode(op, left, parseOperand());
    }
    if (isKeyword("in")) {
      next();
      expect(Token.Kind.open, "'(' after in");
      ODataFilterNode[] list;
      if (peek().kind != Token.Kind.close) {
        while (true) {
          list ~= parseOperand();
          if (peek().kind == Token.Kind.comma) {
            next();
            continue;
          }
          break;
        }
      }
      expect(Token.Kind.close, "')'");
      return new ODataInNode(left, list);
    }
    return left;
  }

  ODataFilterNode parseOperand() {
    auto t = peek();
    if (t.kind == Token.Kind.open) {
      next();
      auto inner = parseOr();
      expect(Token.Kind.close, "')'");
      return inner;
    }
    if (t.kind == Token.Kind.str) {
      next();
      return new ODataLiteralNode(Json(t.text));
    }
    if (t.kind == Token.Kind.end)
      throw new ODataQueryException("Unexpected end of $filter expression");
    if (t.kind != Token.Kind.word)
      throw new ODataQueryException("Unexpected '" ~ t.text ~ "' in $filter");

    next();
    auto word = t.text;

    // function call
    if (peek().kind == Token.Kind.open) {
      auto fn = word.toLower;
      auto arity = fn in functionArity;
      if (arity is null)
        throw new ODataQueryException("Unsupported function '" ~ word ~ "' in $filter");
      next();
      ODataFilterNode[] args;
      while (true) {
        args ~= parseOr();
        if (peek().kind == Token.Kind.comma) {
          next();
          continue;
        }
        expect(Token.Kind.close, "')'");
        break;
      }
      if (args.length < (*arity)[0] || args.length > (*arity)[1])
        throw new ODataQueryException("Function '" ~ word ~ "' expects " ~ ((*arity)[0] == (*arity)[1]
            ? (*arity)[0].to!string : (*arity)[0].to!string ~ "-" ~ (*arity)[1].to!string) ~ " arguments");
      return new ODataFunctionNode(fn, args);
    }

    switch (word) {
    case "true":
      return new ODataLiteralNode(Json(true));
    case "false":
      return new ODataLiteralNode(Json(false));
    case "null":
      return new ODataLiteralNode(Json(null));
    default:
      break;
    }

    if (isDigit(word[0]) || (word.length > 1 && word[0] == '-' && isDigit(word[1]))) {
      try
        return new ODataLiteralNode(Json(word.to!long));
      catch (Exception) {
      }
      try
        return new ODataLiteralNode(Json(word.to!double));
      catch (Exception) {
      }
      return new ODataLiteralNode(Json(word)); // date / time / guid literal
    }

    if (properties.length > 0 && !properties.canFind(word))
      throw new ODataQueryException("Unknown property '" ~ word ~ "' in $filter");
    return new ODataPropertyNode(word);
  }
}

/// Parse a $filter expression. If properties is non-empty, property names are validated.
ODataFilterNode parseODataFilter(string expression, const(string)[] properties = null) {
  auto parser = FilterParser(tokenize(expression), 0, properties);
  return parser.parse();
}

// ─────────────────────────────────────────────────────────────────────────────
// System query options
// ─────────────────────────────────────────────────────────────────────────────

struct ODataOrderBy {
  string property;
  bool descending;
}

/// The result of applying a query to a list of rows.
struct ODataPage {
  Json[] rows; /// the page (after $skip/$top/$select)
  size_t total; /// rows matching $filter/$search (before paging)
  size_t nextSkip; /// > 0 if the server truncated the page (→ @odata.nextLink)
}

struct ODataQuery {
  size_t skip;
  size_t top = size_t.max;
  ODataFilterNode filter;
  ODataOrderBy[] orderBy;
  string[] select;
  bool count;
  string search;

  bool hasTop() const {
    return top != size_t.max;
  }

  /// Apply all options. maxPageSize > 0 enables server-driven paging.
  ODataPage apply(Json[] rows, size_t maxPageSize = 0) const {
    ODataPage page;
    Json[] result;
    foreach (row; rows) {
      if (filter !is null && !odataTruthy(filter.evaluate(row)))
        continue;
      if (search.length > 0 && !matchesSearch(row, search))
        continue;
      result ~= row;
    }
    page.total = result.length;

    if (orderBy.length > 0) {
      auto order = orderBy.dup;
      // stable: equal rows keep the provider's order
      result.sort!((a, b) {
        foreach (o; order) {
          auto av = o.property in a ? a[o.property] : Json(null);
          auto bv = o.property in b ? b[o.property] : Json(null);
          int c;
          if (!odataCompare(av, bv, c)) // nulls sort first
            c = (isNullish(av) ? 0 : 1) - (isNullish(bv) ? 0 : 1);
          if (c != 0)
            return o.descending ? c > 0 : c < 0;
        }
        return false;
      }, SwapStrategy.stable);
    }

    if (skip >= result.length)
      return page;
    result = result[skip .. $];

    size_t limit = top;
    if (maxPageSize > 0 && maxPageSize < limit && maxPageSize < result.length) {
      limit = maxPageSize;
      page.nextSkip = skip + maxPageSize;
    }
    if (limit < result.length)
      result = result[0 .. limit];

    if (select.length > 0) {
      Json[] projected;
      foreach (row; result) {
        auto p = Json.emptyObject;
        foreach (name; select)
          if (name in row)
            p[name] = row[name];
        projected ~= p;
      }
      result = projected;
    }
    page.rows = result;
    return page;
  }
}

private bool matchesSearch(Json row, string term) {
  if (!row.isObject)
    return false;
  auto needle = term.toLower;
  foreach (key, value; row.get!(Json[string])) {
    if (value.type == Json.Type.string && value.get!string.toLower.canFind(needle))
      return true;
    if (value.type == Json.Type.array)
      foreach (item; value.get!(Json[]))
        if (item.type == Json.Type.string && item.get!string.toLower.canFind(needle))
          return true;
  }
  return false;
}

/// Parse the system query options from the request's query parameters.
/// get(name) must return "" for missing parameters.
/// properties: valid property names (empty = no validation); key: always kept by $select.
ODataQuery parseODataQuery(scope string delegate(string) @safe get, const(string)[] properties, string key) {
  ODataQuery q;

  size_t parseCount(string name, string raw) {
    try
      return raw.strip.to!size_t;
    catch (Exception)
      throw new ODataQueryException("Invalid value for " ~ name ~ ": " ~ raw);
  }

  void checkProperty(string option, string name) {
    if (properties.length > 0 && !properties.canFind(name))
      throw new ODataQueryException("Unknown property '" ~ name ~ "' in " ~ option);
  }

  auto expand = get("$expand").strip;
  if (expand.length > 0)
    throw new ODataQueryException("$expand is not supported (no navigation properties)");
  if (get("$apply").strip.length > 0)
    throw new ODataQueryException("$apply is not supported");
  auto format = get("$format").strip.toLower;
  if (format.length > 0 && !format.startsWith("json") && !format.startsWith("application/json"))
    throw new ODataQueryException("Unsupported $format: " ~ format);

  auto top = get("$top");
  if (top.length > 0)
    q.top = parseCount("$top", top);
  auto skip = get("$skip");
  if (skip.length > 0)
    q.skip = parseCount("$skip", skip);
  auto token = get("$skiptoken");
  if (token.length > 0)
    q.skip += parseCount("$skiptoken", token);

  auto filter = get("$filter");
  if (filter.strip.length > 0)
    q.filter = parseODataFilter(filter, properties);

  foreach (part; get("$orderby").split(",")) {
    auto words = part.strip.split!isWhite.filter!(w => w.length > 0).array;
    if (words.length == 0)
      continue;
    if (words.length > 2 || (words.length == 2 && !["asc", "desc"].canFind(words[1].toLower)))
      throw new ODataQueryException("Invalid $orderby item: " ~ part.strip);
    checkProperty("$orderby", words[0]);
    q.orderBy ~= ODataOrderBy(words[0], words.length > 1 && words[1].toLower == "desc");
  }

  auto select = get("$select").strip;
  if (select.length > 0 && select != "*") {
    foreach (name; select.split(",").map!(s => s.strip).filter!(s => s.length > 0)) {
      checkProperty("$select", name);
      if (!q.select.canFind(name))
        q.select ~= name;
    }
    if (key.length > 0 && !q.select.canFind(key))
      q.select ~= key;
  }

  auto countOption = get("$count").strip.toLower;
  if (countOption.length > 0 && countOption != "true" && countOption != "false")
    throw new ODataQueryException("Invalid value for $count: " ~ countOption);
  q.count = countOption == "true";
  q.search = get("$search").strip.strip("\"");
  return q;
}

/// Decode an URL query string ("a=1&b=x%20y") into a map ('+' is a space).
string[string] parseODataQueryString(string queryString) {
  import vibe.textfilter.urlencode : urlDecode;

  string[string] result;
  foreach (pair; queryString.split("&")) {
    if (pair.length == 0)
      continue;
    auto eq = pair.indexOf('=');
    auto name = eq < 0 ? pair : pair[0 .. eq];
    auto value = eq < 0 ? "" : pair[eq + 1 .. $];
    try
      result[urlDecode(name.replace("+", " "))] = urlDecode(value.replace("+", " "));
    catch (Exception)
      throw new ODataQueryException("Malformed query parameter: " ~ name);
  }
  return result;
}

///
unittest {
  mixin(ShowTest!("ODataQuery"));

  Json row(string id, string cat, long n, string msg, string at = "2026-11-09T10:00:00Z") {
    auto r = Json.emptyObject;
    r["id"] = id;
    r["category"] = cat;
    r["n"] = n;
    r["message"] = msg;
    r["at"] = at;
    return r;
  }

  auto rows = [
    row("1", "dataAccess", 3, "Read profile"), row("2", "configuration", 1, "Changed IdP", "2025-01-02T00:00:00Z"),
    row("3", "dataAccess", 2, "Read payroll")
  ];
  auto props = ["id", "category", "n", "message", "at"];

  auto f = parseODataFilter("category eq 'dataAccess' and n ge 3", props);
  assert(odataTruthy(f.evaluate(rows[0])));
  assert(!odataTruthy(f.evaluate(rows[2])));

  assert(odataTruthy(parseODataFilter("contains(message,'PAYROLL')", props).evaluate(rows[2])));
  assert(odataTruthy(parseODataFilter("not (n lt 2) or startswith(id,'2')", props).evaluate(rows[1])));
  assert(odataTruthy(parseODataFilter("message eq 'It''s'", props).evaluate(row("4", "", 0, "It's"))));
  assert(odataTruthy(parseODataFilter("category in ('configuration', 'x')", props).evaluate(rows[1])));
  assert(!odataTruthy(parseODataFilter("category in ('x')", props).evaluate(rows[1])));
  assert(odataTruthy(parseODataFilter("year(at) eq 2025 and month(at) eq 1", props).evaluate(rows[1])));
  assert(odataTruthy(parseODataFilter("at lt 2026-01-01", props).evaluate(rows[1])));
  assert(odataTruthy(parseODataFilter("length(message) eq 12 and substring(message,0,4) eq 'Read'", props)
      .evaluate(rows[2])));
  assert(odataTruthy(parseODataFilter("indexof(message,'pay') eq 5", props).evaluate(rows[2])));

  foreach (bad; ["unknown eq 1", "n eq", "contains(message)", "'open", "n eq 1)", "foo(n)"]) {
    bool failed;
    try
      parseODataFilter(bad, props);
    catch (ODataQueryException)
      failed = true;
    assert(failed, bad);
  }

  string[string] params = [
    "$filter": "category eq 'dataAccess'", "$orderby": "n desc", "$top": "1", "$select": "message", "$count": "true"
  ];
  auto q = parseODataQuery((name) => params.get(name, ""), props, "id");
  auto page = q.apply(rows);
  assert(q.count);
  assert(page.total == 2);
  assert(page.rows.length == 1);
  assert(page.rows[0]["message"].get!string == "Read profile");
  assert("id" in page.rows[0] && "category" !in page.rows[0]);

  // server driven paging
  string[string] none;
  auto all = parseODataQuery((name) => none.get(name, ""), props, "id");
  auto first = all.apply(rows, 2);
  assert(first.rows.length == 2 && first.nextSkip == 2);
  string[string] next = ["$skiptoken": "2"];
  auto second = parseODataQuery((name) => next.get(name, ""), props, "id").apply(rows, 2);
  assert(second.rows.length == 1 && second.nextSkip == 0);

  string[string] search = ["$search": "payroll"];
  assert(parseODataQuery((name) => search.get(name, ""), props, "id").apply(rows).rows.length == 1);

  string[string] expand = ["$expand": "Items"];
  bool rejected;
  try
    parseODataQuery((name) => expand.get(name, ""), props, "id");
  catch (ODataQueryException)
    rejected = true;
  assert(rejected);

  auto qs = parseODataQueryString("$filter=name%20eq%20'a+b'&$top=5&flag");
  assert(qs["$filter"] == "name eq 'a b'");
  assert(qs["$top"] == "5" && qs["flag"] == "");
}
