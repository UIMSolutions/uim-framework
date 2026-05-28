/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.connection;

import vibe.d : runTask;

import uim.sql;

mixin(ShowModule!());

@safe:

class UIMSqlConnection : UIMObject, ISqlConnection {
  private bool _open = false;
  private bool _inTransaction = false;
  private string _connectionString;
  private ISqlDriver _driver;

  this(ISqlDriver driver = null) {
    super();
    _driver = driver;
  }

  bool open(string connectionString) {
    if (connectionString.length == 0) {
      return false;
    }
    _connectionString = connectionString;
    if (_driver !is null && !_driver.open(connectionString)) {
      return false;
    }
    _open = true;
    return true;
  }

  bool close() {
    if (!_open) {
      return false;
    }
    if (_driver !is null) {
      _driver.close();
    }
    _inTransaction = false;
    _open = false;
    return true;
  }

  bool isOpen() {
    return _open;
  }

  ISqlResult query(string sql, SqlParameter[] params = null) {
    if (!_open || sql.length == 0) {
      return SqlResult();
    }
    if (_driver !is null) {
      return _driver.query(sql, params is null ? [] : params);
    }
    return SqlResult();
  }

  int execute(string sql, SqlParameter[] params = null) {
    if (!_open || sql.length == 0) {
      return -1;
    }
    if (_driver !is null) {
      return _driver.execute(sql, params is null ? [] : params);
    }
    return 0;
  }

  private ISqlResult queryNoThrow(string sql, SqlParameter[] params) nothrow @trusted {
    try {
      return query(sql, params);
    } catch (Throwable) {
      try {
        return SqlResult();
      } catch (Throwable) {
        return null;
      }
    }
  }

  void queryAsync(string sql, SqlParameter[] params, void delegate(ISqlResult) @safe callback) @trusted {
    if (callback is null) {
      return;
    }

    auto localSql = sql;
    auto localParams = params.dup;
    auto localCallback = callback;

    runTask(() nothrow {
      auto result = queryNoThrow(localSql, localParams);
      try {
        localCallback(result);
      } catch (Throwable) {
      }
    });
  }

  bool beginTransaction() {
    if (!_open || _inTransaction) {
      return false;
    }
    if (_driver !is null) {
      _driver.beginTransaction();
    }
    _inTransaction = true;
    return true;
  }

  bool commit() {
    if (!_open || !_inTransaction) {
      return false;
    }
    if (_driver !is null) {
      _driver.commit();
    }
    _inTransaction = false;
    return true;
  }

  bool rollback() {
    if (!_open || !_inTransaction) {
      return false;
    }
    if (_driver !is null) {
      _driver.rollback();
    }
    _inTransaction = false;
    return true;
  }

  bool inTransaction() {
    return _inTransaction;
  }

  string connectionString() {
    return _connectionString;
  }

  string driverName() {
    return _driver !is null ? _driver.name() : "null";
  }
}

auto SqlConnection(ISqlDriver driver = null) {
  return new UIMSqlConnection(driver);
}

unittest {
  auto conn = SqlConnection();
  assert(conn.open("sql://localhost/testdb"));
  assert(conn.isOpen());
  assert(conn.driverName() == "null");

  auto result = conn.query("SELECT 1");
  assert(result.rowCount() == 0);

  assert(conn.beginTransaction());
  assert(conn.inTransaction());
  assert(conn.commit());
  assert(!conn.inTransaction());

  assert(conn.close());
  assert(!conn.isOpen());
}
