/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.drivers.loopback;

import uim.sql;

mixin(ShowModule!());

@safe:

/// In-process SQL driver for testing and service-first development.
/// Register SQL string handlers; unrecognised statements fall through to a
/// configurable default handler or return an empty result/zero row-count.
class UIMSqlLoopbackDriver : UIMObject, ISqlDriver {
  alias QueryHandler = ISqlResult delegate(string sql, SqlParameter[] params) @safe;
  alias ExecHandler  = int delegate(string sql, SqlParameter[] params) @safe;

  private QueryHandler[string] _queryHandlers;
  private ExecHandler[string]  _execHandlers;
  private QueryHandler         _defaultQueryHandler;
  private bool                 _opened;

  // ── Registration ────────────────────────────────────────────────────────

  UIMSqlLoopbackDriver registerQuery(string sql, QueryHandler handler) {
    _queryHandlers[sql] = handler;
    return this;
  }

  UIMSqlLoopbackDriver registerExec(string sql, ExecHandler handler) {
    _execHandlers[sql] = handler;
    return this;
  }

  UIMSqlLoopbackDriver setDefaultQuery(QueryHandler handler) {
    _defaultQueryHandler = handler;
    return this;
  }

  /// Convenience: preset a fixed row set for an exact SQL statement.
  UIMSqlLoopbackDriver presetRows(string sql, string[string][] rows) {
    auto localRows = rows.dup;
    _queryHandlers[sql] = (string s, SqlParameter[] p) @safe {
      ISqlRow[] result;
      foreach (row; localRows) {
        result ~= SqlRow(row);
      }
      return SqlResult(result);
    };
    return this;
  }

  // ── ISqlDriver ──────────────────────────────────────────────────────────

  bool open(string connectionString) {
    _opened = true;
    return true;
  }

  bool close() {
    _opened = false;
    return true;
  }

  ISqlResult query(string sql, SqlParameter[] params) {
    auto handler = sql in _queryHandlers;
    if (handler !is null) {
      return (*handler)(sql, params);
    }
    if (_defaultQueryHandler !is null) {
      return _defaultQueryHandler(sql, params);
    }
    return SqlResult();
  }

  int execute(string sql, SqlParameter[] params) {
    auto handler = sql in _execHandlers;
    if (handler !is null) {
      return (*handler)(sql, params);
    }
    return 0;
  }

  void beginTransaction() { }
  void commit()           { }
  void rollback()         { }

  string name() { return "loopback"; }
}

auto SqlLoopbackDriver() {
  return new UIMSqlLoopbackDriver();
}

// ── Unit tests ────────────────────────────────────────────────────────────

unittest {
  auto driver = SqlLoopbackDriver();
  driver.presetRows("SELECT * FROM users", [
    ["id": "1", "name": "Alice"],
    ["id": "2", "name": "Bob"]
  ]);

  auto conn = SqlConnection(driver);
  assert(conn.open("loopback://"));
  assert(conn.driverName() == "loopback");

  auto result = conn.query("SELECT * FROM users", null);
  assert(result.rowCount() == 2);

  assert(!result.empty());
  assert(result.front().text("name") == "Alice");
  result.popFront();
  assert(result.front().text("name") == "Bob");
  result.popFront();
  assert(result.empty());

  assert(conn.close());
}

unittest {
  auto driver = SqlLoopbackDriver();
  driver.registerExec(
    "DELETE FROM sessions WHERE expired = ?",
    (string sql, SqlParameter[] params) @safe { return 3; }
  );

  auto conn = SqlConnection(driver);
  assert(conn.open("loopback://"));

  auto q = sqlDelete("sessions").where_("expired = ?", sqlBool(true)).build();
  int affected = conn.execute(q.sql, q.params);
  assert(affected == 3);

  assert(conn.close());
}

unittest {
  auto driver = SqlLoopbackDriver();
  auto conn = SqlConnection(driver);
  assert(conn.open("loopback://"));

  auto q = sqlInsert("products")
    .set_("name", sqlText("Widget"))
    .set_("price", sqlFloat(9.99))
    .build();

  assert(q.sql == "INSERT INTO products (name, price) VALUES (?, ?)");
  assert(q.params.length == 2);
  assert(conn.execute(q.sql, q.params) == 0);

  assert(conn.close());
}
