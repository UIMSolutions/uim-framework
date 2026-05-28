/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.result;

import uim.sql;

mixin(ShowModule!());

@safe:

class UIMSqlRow : UIMObject, ISqlRow {
  private string[string] _data;

  this(string[string] data) {
    super();
    foreach (k, v; data) {
      _data[k] = v;
    }
  }

  string text(string columnName) {
    return _data.get(columnName, "");
  }

  long integer_(string columnName) {
    import std.conv : to;
    auto v = _data.get(columnName, "");
    return v.length ? v.to!long : 0L;
  }

  double float_(string columnName) {
    import std.conv : to;
    auto v = _data.get(columnName, "");
    return v.length ? v.to!double : 0.0;
  }

  bool boolean_(string columnName) {
    auto v = _data.get(columnName, "");
    return v == "1" || v == "true";
  }

  bool isNull(string columnName) {
    return (columnName in _data) is null;
  }

  string[] columnNames() {
    return _data.keys.dup;
  }
}

class UIMSqlResult : UIMObject, ISqlResult {
  private ISqlRow[] _rows;
  private size_t _pos;
  private SqlColumnInfo[] _columns;

  this(ISqlRow[] rows = null, SqlColumnInfo[] columns = null) {
    super();
    _rows = rows !is null ? rows.dup : [];
    _columns = columns !is null ? columns.dup : [];
  }

  bool empty() {
    return _pos >= _rows.length;
  }

  ISqlRow front() {
    return _rows[_pos];
  }

  void popFront() {
    if (!empty()) {
      _pos++;
    }
  }

  size_t rowCount() {
    return _rows.length;
  }

  SqlColumnInfo[] columns() {
    return _columns.dup;
  }

  void close() {
    _pos = _rows.length;
  }
}

// ── Factory helpers ───────────────────────────────────────────────────────

UIMSqlRow SqlRow(string[string] data) {
  return new UIMSqlRow(data);
}

UIMSqlResult SqlResult(ISqlRow[] rows = null, SqlColumnInfo[] columns = null) {
  return new UIMSqlResult(rows, columns);
}

// ── Unit tests ────────────────────────────────────────────────────────────

unittest {
  auto row = SqlRow(["id": "1", "name": "Alice", "age": "30"]);
  assert(row.text("name") == "Alice");
  assert(row.integer_("age") == 30);
  assert(row.isNull("missing"));
  assert(!row.isNull("id"));
}

unittest {
  auto result = SqlResult([
    SqlRow(["id": "1", "name": "Alice"]),
    SqlRow(["id": "2", "name": "Bob"])
  ]);

  assert(result.rowCount() == 2);
  assert(!result.empty());

  assert(result.front().text("name") == "Alice");
  result.popFront();
  assert(result.front().text("name") == "Bob");
  result.popFront();
  assert(result.empty());
}
