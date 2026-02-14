/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.interfaces.engine;

import uim.databases;

mixin(ShowModule!());

@safe:

/// Interface for database engine implementations
interface IDatabaseEngine {
  /// Create a new table with specified name and columns
  /// Returns: reference to created table
  Table createTable(string name, string[] columns);
  
  /// Get existing table by name
  /// Returns: table reference or null if not found
  Table getTable(string name);
  
  /// Check if table exists
  bool hasTable(string name) const;
  
  /// Drop/delete a table
  IDatabaseEngine dropTable(string name);
  
  /// Get all table names
  string[] tableNames() const;
  
  /// Get total row count across all tables
  ulong rowCount() const;
  
  /// Clear all tables and data
  IDatabaseEngine clear();
  
  /// Get all tables
  const(Table[string]) tables() const;
}
