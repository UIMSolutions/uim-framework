/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.interfaces.result;

@safe:

enum SqlColumnType {
  text,
  integer_,
  float_,
  boolean_,
  blob,
  null_
}

struct SqlColumnInfo {
  string name;
  SqlColumnType type;
}

interface ISqlRow {
  string text(string columnName);
  long integer_(string columnName);
  double float_(string columnName);
  bool boolean_(string columnName);
  bool isNull(string columnName);
  string[] columnNames();
}

interface ISqlResult {
  bool empty();
  ISqlRow front();
  void popFront();
  size_t rowCount();
  SqlColumnInfo[] columns();
  void close();
}
