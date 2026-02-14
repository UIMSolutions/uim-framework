/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.interfaces.table;

import uim.databases;

mixin(ShowModule!());

@safe:

/// Interface for table objects
interface ITable {
  /// Get table name
  @property string name() const;
  
  /// Get column names
  @property const(string[]) columns() const;
  
  /// Get row count
  @property ulong rowCount() const;
  
  /// Insert single row
  ITable insert(TableRow row);
  
  /// Insert multiple rows as batch
  ITable insertBatch(TableRow[] rows);
  
  /// Select rows with optional filter, sorting, limit
  TableRow[] select(
    scope bool delegate(const TableRow) @safe filter = null,
    string orderBy = "",
    bool ascending = true,
    ulong limit = 0,
    ulong offset = 0
  );
  
  /// Count rows matching filter
  ulong count(scope bool delegate(const TableRow) @safe filter = null) const;
  
  /// Update rows matching filter
  ulong update(
    scope bool delegate(const TableRow) @safe filter,
    scope TableRow delegate(const TableRow) @safe updateFn
  );
  
  /// Delete rows matching filter
  ulong delete_(scope bool delegate(const TableRow) @safe filter);
  
  /// Clear all rows
  ITable clear();
  
  /// Create index on column for faster queries
  ITable createIndex(string column);
  
  /// Check if column has index
  bool hasIndex(string column) const;
}
