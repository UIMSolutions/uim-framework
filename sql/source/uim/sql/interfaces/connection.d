/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.interfaces.connection;

import uim.sql.interfaces.result;
import uim.sql.helpers.parameters;

@safe:

interface ISqlDriver {
  bool open(string connectionString);
  bool close();
  ISqlResult query(string sql, SqlParameter[] params);
  int execute(string sql, SqlParameter[] params);
  void beginTransaction();
  void commit();
  void rollback();
  string name();
}

interface ISqlConnection {
  bool open(string connectionString);
  bool close();
  bool isOpen();

  ISqlResult query(string sql, SqlParameter[] params);
  int execute(string sql, SqlParameter[] params);
  void queryAsync(string sql, SqlParameter[] params, void delegate(ISqlResult) @safe callback);

  bool beginTransaction();
  bool commit();
  bool rollback();
  bool inTransaction();

  string connectionString();
  string driverName();
}
