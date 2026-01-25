/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.interfaces.table;

import uim.databases;
@safe:
interface ITable {
  /// Get table name
  @property string name() const @safe;
  
  /// Get column names
  @property const(string[]) columns() const @safe;
  
  /// Get row count
  @property ulong rowCount() const @safe;
  
  /// Insert single row
  void insert(TableRow row) @safe;
  
  /// Insert multiple rows as batch
  void insertBatch(TableRow[] rows) @safe;
  
  /// Select rows with optional filter, sorting, limit
  TableRow[] select(
    scope bool delegate(const TableRow) @safe filter = null,
    string orderBy = "",
    bool ascending = true,
    ulong limit = 0,
    ulong offset = 0
  ) @safe;
  
  /// Count rows matching filter
  ulong count(scope bool delegate(const TableRow) @safe filter = null) const @safe;
  
  /// Update rows matching filter
  ulong update(
    scope bool delegate(const TableRow) @safe filter,
    scope TableRow delegate(const TableRow) @safe updateFn
  ) @safe;
  
  /// Delete rows matching filter
  ulong delete_(scope bool delegate(const TableRow) @safe filter) @safe;
  
  /// Clear all rows
  void clear() @safe;
  
  /// Create index on column for faster queries
  void createIndex(string column) @safe;
  
  /// Check if column has index
  bool hasIndex(string column) const @safe;
}
