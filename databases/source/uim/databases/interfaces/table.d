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
  string name() const;
  
  /// Get column names
  const(string[]) columns() const;
  
  /// Get row count
  size_t rowCount() const;
  
  /// Insert single row
  ITable insert(ITableRow row);
  
  /// Insert multiple rows as batch
  ITable insertBatch(ITableRow[] rows);
  
  /// Select rows with optional filter, sorting, limit
  ITableRow[] select(
    scope bool delegate(const ITableRow) @safe filter = null,
    string orderBy = "",
    bool ascending = true,
    size_t limit = 0,
    size_t offset = 0
  );
  
  /// Count rows matching filter
  size_t count(scope bool delegate(const ITableRow) @safe filter = null) const;
  

  /// Update rows matching filter
  size_t update(
    scope bool delegate(const ITableRow) @safe filter,
    scope ITableRow delegate(const ITableRow) @safe updateFn
  );
  
  /// Delete rows matching filter
  size_t delete_(scope bool delegate(const ITableRow) @safe filter);
  
  /// Clear all rows
  ITable clear();
  
  /// Create index on column for faster queries
  ITable createIndex(string column);
  
  /// Check if column has index
  bool hasIndex(string column) const;
}
