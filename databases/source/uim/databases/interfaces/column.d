/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.interfaces.column;

import uim.databases;

mixin(ShowModule!());

@safe:

/// Interface for table column objects
interface ITableColumn {
  /// Get column name
  string name() const;

  /// Get column type
  string type() const;

  /// Set column type
  @property ITableColumn type(string newType);
}