/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.query.builder;

import std.array : join;
import std.conv : to;

import uim.sql.helpers.parameters;

@safe:

/// Immutable result of a builder — holds the parameterised SQL string
/// and the ordered parameter list ready for execution.
struct SqlQuery {
  string sql;
  SqlParameter[] params;
}

// ══════════════════════════════════════════════════════════════════════════
// SELECT builder
// ══════════════════════════════════════════════════════════════════════════

class SqlSelectBuilder {
  private string _table;
  private string[] _columns;
  private string[] _joins;
  private string[] _whereClauses;
  private SqlParameter[] _whereParams;
  private string[] _orderByClauses;
  private uint _limit;
  private uint _offset;

  this(string table) {
    _table = table;
  }

  SqlSelectBuilder select_(string[] columns...) {
    foreach (c; columns) {
      _columns ~= c;
    }
    return this;
  }

  SqlSelectBuilder join_(string joinClause) {
    _joins ~= joinClause;
    return this;
  }

  /// Appends a WHERE condition with a bound parameter.
  SqlSelectBuilder where_(string condition, SqlValue value) {
    _whereClauses ~= condition;
    SqlParameter p;
    p.value = value;
    _whereParams ~= p;
    return this;
  }

  /// Appends a parameterless WHERE condition (e.g. "deleted_at IS NULL").
  SqlSelectBuilder where_(string condition) {
    _whereClauses ~= condition;
    return this;
  }

  SqlSelectBuilder orderBy(string column, bool ascending = true) {
    _orderByClauses ~= column ~ (ascending ? " ASC" : " DESC");
    return this;
  }

  SqlSelectBuilder limit_(uint n) {
    _limit = n;
    return this;
  }

  SqlSelectBuilder offset_(uint n) {
    _offset = n;
    return this;
  }

  SqlQuery build() {
    string sql = "SELECT ";
    sql ~= _columns.length ? _columns.join(", ") : "*";
    sql ~= " FROM " ~ _table;

    foreach (j; _joins) {
      sql ~= " " ~ j;
    }

    if (_whereClauses.length) {
      sql ~= " WHERE " ~ _whereClauses.join(" AND ");
    }
    if (_orderByClauses.length) {
      sql ~= " ORDER BY " ~ _orderByClauses.join(", ");
    }
    if (_limit > 0) {
      sql ~= " LIMIT " ~ _limit.to!string;
    }
    if (_offset > 0) {
      sql ~= " OFFSET " ~ _offset.to!string;
    }

    auto params = _whereParams.dup;
    foreach (i, ref p; params) {
      p.index = cast(int) i + 1;
    }

    return SqlQuery(sql, params);
  }
}

// ══════════════════════════════════════════════════════════════════════════
// INSERT builder
// ══════════════════════════════════════════════════════════════════════════

class SqlInsertBuilder {
  private string _table;
  private string[] _columns;
  private SqlParameter[] _values;

  this(string table) {
    _table = table;
  }

  SqlInsertBuilder set_(string column, SqlValue value) {
    _columns ~= column;
    SqlParameter p;
    p.value = value;
    _values ~= p;
    return this;
  }

  SqlQuery build() {
    if (_columns.length == 0) {
      return SqlQuery("", null);
    }

    string[] placeholders;
    foreach (_; 0 .. _columns.length) {
      placeholders ~= "?";
    }

    string sql = "INSERT INTO " ~ _table
      ~ " (" ~ _columns.join(", ") ~ ")"
      ~ " VALUES (" ~ placeholders.join(", ") ~ ")";

    auto params = _values.dup;
    foreach (i, ref p; params) {
      p.index = cast(int) i + 1;
    }

    return SqlQuery(sql, params);
  }
}

// ══════════════════════════════════════════════════════════════════════════
// UPDATE builder
// ══════════════════════════════════════════════════════════════════════════

class SqlUpdateBuilder {
  private string _table;
  private string[] _setClauses;
  private SqlParameter[] _setParams;
  private string[] _whereClauses;
  private SqlParameter[] _whereParams;

  this(string table) {
    _table = table;
  }

  SqlUpdateBuilder set_(string column, SqlValue value) {
    _setClauses ~= column ~ " = ?";
    SqlParameter p;
    p.value = value;
    _setParams ~= p;
    return this;
  }

  SqlUpdateBuilder where_(string condition, SqlValue value) {
    _whereClauses ~= condition;
    SqlParameter p;
    p.value = value;
    _whereParams ~= p;
    return this;
  }

  SqlUpdateBuilder where_(string condition) {
    _whereClauses ~= condition;
    return this;
  }

  SqlQuery build() {
    if (_setClauses.length == 0) {
      return SqlQuery("", null);
    }

    string sql = "UPDATE " ~ _table ~ " SET " ~ _setClauses.join(", ");

    if (_whereClauses.length) {
      sql ~= " WHERE " ~ _whereClauses.join(" AND ");
    }

    SqlParameter[] params = _setParams ~ _whereParams;
    foreach (i, ref p; params) {
      p.index = cast(int) i + 1;
    }

    return SqlQuery(sql, params);
  }
}

// ══════════════════════════════════════════════════════════════════════════
// DELETE builder
// ══════════════════════════════════════════════════════════════════════════

class SqlDeleteBuilder {
  private string _table;
  private string[] _whereClauses;
  private SqlParameter[] _whereParams;

  this(string table) {
    _table = table;
  }

  SqlDeleteBuilder where_(string condition, SqlValue value) {
    _whereClauses ~= condition;
    SqlParameter p;
    p.value = value;
    _whereParams ~= p;
    return this;
  }

  SqlDeleteBuilder where_(string condition) {
    _whereClauses ~= condition;
    return this;
  }

  SqlQuery build() {
    string sql = "DELETE FROM " ~ _table;

    if (_whereClauses.length) {
      sql ~= " WHERE " ~ _whereClauses.join(" AND ");
    }

    auto params = _whereParams.dup;
    foreach (i, ref p; params) {
      p.index = cast(int) i + 1;
    }

    return SqlQuery(sql, params);
  }
}

// ── Factory helpers ───────────────────────────────────────────────────────

auto sqlSelect(string table) @safe { return new SqlSelectBuilder(table); }
auto sqlInsert(string table) @safe { return new SqlInsertBuilder(table); }
auto sqlUpdate(string table) @safe { return new SqlUpdateBuilder(table); }
auto sqlDelete(string table) @safe { return new SqlDeleteBuilder(table); }

// ── Unit tests ────────────────────────────────────────────────────────────

unittest {
  auto q = sqlSelect("users")
    .select_("id", "name", "email")
    .where_("age > ?", sqlInt(30))
    .where_("status = ?", sqlText("active"))
    .orderBy("name")
    .limit_(10)
    .build();

  assert(q.sql == "SELECT id, name, email FROM users WHERE age > ? AND status = ? ORDER BY name ASC LIMIT 10");
  assert(q.params.length == 2);
  assert(q.params[0].value.intValue == 30);
  assert(q.params[1].value.textValue == "active");
}

unittest {
  auto q = sqlInsert("orders")
    .set_("user_id", sqlInt(1))
    .set_("total", sqlFloat(99.95))
    .set_("note", sqlNull())
    .build();

  assert(q.sql == "INSERT INTO orders (user_id, total, note) VALUES (?, ?, ?)");
  assert(q.params.length == 3);
  assert(q.params[0].index == 1);
  assert(q.params[1].value.floatValue == 99.95);
  assert(q.params[2].value.isNull());
}

unittest {
  auto q = sqlUpdate("users")
    .set_("name", sqlText("Bob"))
    .set_("active", sqlBool(true))
    .where_("id = ?", sqlInt(42))
    .build();

  assert(q.sql == "UPDATE users SET name = ?, active = ? WHERE id = ?");
  assert(q.params.length == 3);
  assert(q.params[2].value.intValue == 42);
}

unittest {
  auto q = sqlDelete("sessions")
    .where_("expired = ?", sqlBool(true))
    .build();

  assert(q.sql == "DELETE FROM sessions WHERE expired = ?");
  assert(q.params.length == 1);
}
