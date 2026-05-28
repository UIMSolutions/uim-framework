/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.helpers.parameters;

@safe:

enum SqlValueType { text, integer_, float_, boolean_, null_ }

/// Typed scalar value used for parameterised SQL binding.
/// Using explicit typed fields instead of a union avoids @system casts.
struct SqlValue {
  SqlValueType type = SqlValueType.null_;
  string textValue;
  long intValue;
  double floatValue;
  bool boolValue;

  bool isNull() const pure nothrow { return type == SqlValueType.null_; }

  string toString() const {
    import std.conv : to;
    final switch (type) {
      case SqlValueType.text:     return textValue;
      case SqlValueType.integer_: return intValue.to!string;
      case SqlValueType.float_:   return floatValue.to!string;
      case SqlValueType.boolean_: return boolValue ? "true" : "false";
      case SqlValueType.null_:    return "NULL";
    }
  }
}

/// A single bound parameter — either positional (index >= 1) or named (:name).
struct SqlParameter {
  string name;
  int index;
  SqlValue value;
}

// ── Value factory helpers ─────────────────────────────────────────────────

SqlValue sqlText(string value) pure nothrow @safe {
  SqlValue v;
  v.type = SqlValueType.text;
  v.textValue = value;
  return v;
}

SqlValue sqlInt(long value) pure nothrow @safe {
  SqlValue v;
  v.type = SqlValueType.integer_;
  v.intValue = value;
  return v;
}

SqlValue sqlFloat(double value) pure nothrow @safe {
  SqlValue v;
  v.type = SqlValueType.float_;
  v.floatValue = value;
  return v;
}

SqlValue sqlBool(bool value) pure nothrow @safe {
  SqlValue v;
  v.type = SqlValueType.boolean_;
  v.boolValue = value;
  return v;
}

SqlValue sqlNull() pure nothrow @safe { return SqlValue(); }

// ── Parameter factory helpers ─────────────────────────────────────────────

SqlParameter sqlParam(string name, SqlValue value) pure nothrow @safe {
  SqlParameter p;
  p.name = name;
  p.value = value;
  return p;
}

SqlParameter sqlParam(int index, SqlValue value) pure nothrow @safe {
  SqlParameter p;
  p.index = index;
  p.value = value;
  return p;
}

unittest {
  auto v = sqlText("hello");
  assert(v.type == SqlValueType.text);
  assert(v.textValue == "hello");

  auto i = sqlInt(42);
  assert(i.type == SqlValueType.integer_);
  assert(i.intValue == 42);

  auto n = sqlNull();
  assert(n.isNull());

  auto p = sqlParam("user_id", sqlInt(7));
  assert(p.name == "user_id");
  assert(p.value.intValue == 7);
}
