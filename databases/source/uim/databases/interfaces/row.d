/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.interfaces.row;

import uim.databases;

@safe:

/// Interface for table row objects
interface ITableRow {
  /// Get all cells as key-value pairs
  @property Json[string] data() const;

  /// Set all cells from key-value pairs
  @property void data(Json[string] values);

  /// Get value of a specific cell by column name
  Json get(string column) const;

  /// Set value of a specific cell by column name
  ITableRow set(string column, Json value);

  /// Check if a column exists in the row
  bool has(string column) const;

  /// Remove a column from the row
  ITableRow remove(string column);

  /// Get all column names
  @property string[] columns() const;

  /// Get number of columns
  @property size_t columnCount() const;

  /// Clear all cells
  ITableRow clear();

  /// Check if row is empty
  @property bool empty() const;

  /// Convert to string representation
  string toString();
}
