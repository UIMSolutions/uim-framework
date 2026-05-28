/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.types.filter;

@safe:

// SCIM filter comparison and logical operators (RFC 7644 §3.4.2.2)
enum ScimFilterOp {
  eq,   // attribute eq "value"      — equal (case-insensitive for strings)
  ne,   // attribute ne "value"      — not equal
  co,   // attribute co "value"      — contains
  sw,   // attribute sw "value"      — starts with
  ew,   // attribute ew "value"      — ends with
  pr,   // attribute pr              — present (non-empty)
  gt,   // attribute gt "value"      — greater than
  lt,   // attribute lt "value"      — less than
  ge,   // attribute ge "value"      — greater than or equal
  le,   // attribute le "value"      — less than or equal
  not_, // not (filter)              — logical NOT
  and_, // filter and filter         — logical AND
  or_,  // filter or  filter         — logical OR
}

// SCIM filter expression tree node
struct ScimFilter {
  ScimFilterOp op       = ScimFilterOp.pr;
  string       attrPath;          // attribute path for leaf operations
  string       value;             // comparison value for leaf operations
  ScimFilter[] children;          // sub-filters for and_/or_/not_

  // --- leaf factories ---

  static ScimFilter eq(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.eq, attr, val, []);
  }
  static ScimFilter ne(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.ne, attr, val, []);
  }
  static ScimFilter co(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.co, attr, val, []);
  }
  static ScimFilter sw(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.sw, attr, val, []);
  }
  static ScimFilter ew(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.ew, attr, val, []);
  }
  static ScimFilter pr(string attr) nothrow {
    return ScimFilter(ScimFilterOp.pr, attr, "", []);
  }
  static ScimFilter gt(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.gt, attr, val, []);
  }
  static ScimFilter lt(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.lt, attr, val, []);
  }
  static ScimFilter ge(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.ge, attr, val, []);
  }
  static ScimFilter le(string attr, string val) nothrow {
    return ScimFilter(ScimFilterOp.le, attr, val, []);
  }

  // --- logical factories ---

  static ScimFilter not_(ScimFilter child) nothrow {
    return ScimFilter(ScimFilterOp.not_, "", "", [child]);
  }
  static ScimFilter and_(ScimFilter left, ScimFilter right) nothrow {
    return ScimFilter(ScimFilterOp.and_, "", "", [left, right]);
  }
  static ScimFilter or_(ScimFilter left, ScimFilter right) nothrow {
    return ScimFilter(ScimFilterOp.or_, "", "", [left, right]);
  }

  // Simple single-expression parser: "attr op \"value\"" or "attr pr"
  // Use factory methods for compound (and/or/not) filters.
  static ScimFilter parse(string filterStr) {
    import std.string : strip, toLower;

    auto s = filterStr.strip;
    if (s.length == 0) return ScimFilter.pr("");

    // find first whitespace = end of attrPath
    size_t i1 = 0;
    while (i1 < s.length && s[i1] != ' ') i1++;
    if (i1 >= s.length) return ScimFilter.pr(s);

    string attr  = s[0 .. i1];
    auto   rest1 = s[i1 + 1 .. $].strip;

    // find second whitespace = end of operator token
    size_t i2 = 0;
    while (i2 < rest1.length && rest1[i2] != ' ') i2++;
    string opStr = rest1[0 .. i2].toLower;

    if (opStr == "pr") return ScimFilter.pr(attr);
    if (i2 >= rest1.length) return ScimFilter.pr(attr);

    // raw value — strip surrounding double-quotes
    string rawVal = rest1[i2 + 1 .. $].strip;
    if (rawVal.length >= 2 && rawVal[0] == '"' && rawVal[$ - 1] == '"') {
      rawVal = rawVal[1 .. $ - 1];
    }

    switch (opStr) {
      case "eq": return ScimFilter.eq(attr, rawVal);
      case "ne": return ScimFilter.ne(attr, rawVal);
      case "co": return ScimFilter.co(attr, rawVal);
      case "sw": return ScimFilter.sw(attr, rawVal);
      case "ew": return ScimFilter.ew(attr, rawVal);
      case "gt": return ScimFilter.gt(attr, rawVal);
      case "lt": return ScimFilter.lt(attr, rawVal);
      case "ge": return ScimFilter.ge(attr, rawVal);
      case "le": return ScimFilter.le(attr, rawVal);
      default:   return ScimFilter.pr(attr);
    }
  }

  unittest {
    auto f1 = ScimFilter.parse(`userName eq "alice"`);
    assert(f1.op == ScimFilterOp.eq);
    assert(f1.attrPath == "userName");
    assert(f1.value == "alice");

    auto f2 = ScimFilter.parse("active pr");
    assert(f2.op == ScimFilterOp.pr);
    assert(f2.attrPath == "active");

    auto f3 = ScimFilter.parse(`displayName co "Admin"`);
    assert(f3.op == ScimFilterOp.co);
    assert(f3.value == "Admin");

    auto f4 = ScimFilter.and_(
      ScimFilter.eq("userName", "bob"),
      ScimFilter.eq("active", "true")
    );
    assert(f4.op == ScimFilterOp.and_);
    assert(f4.children.length == 2);
    assert(f4.children[0].attrPath == "userName");

    auto f5 = ScimFilter.not_(ScimFilter.pr("password"));
    assert(f5.op == ScimFilterOp.not_);
    assert(f5.children.length == 1);
  }
}
