/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.interfaces.engine;

import uim.databases;
@safe:

interface IDatabaseEngine {
  /// Create a new table with specified name and columns
  /// Returns: reference to created table
  Table createTable(string name, string[] columns) @safe;
  
  /// Get existing table by name
  /// Returns: table reference or null if not found
  Table getTable(string name) @safe;
  
  /// Check if table exists
  bool hasTable(string name) const @safe;
  
  /// Drop/delete a table
  void dropTable(string name) @safe;
  
  /// Get all table names
  string[] tableNames() const @safe;
  
  /// Get total row count across all tables
  ulong rowCount() const @safe;
  
  /// Clear all tables and data
  void clear() @safe;
  
  /// Get all tables
  const(Table[string]) tables() const @safe;
}
