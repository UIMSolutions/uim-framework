/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.classify;

import uim.core;

mixin(ShowModule!());

@safe:

// Returns uim model class name ("Person" for the database table "people".) for given database table.
string[] classify(string[] tableNames) {
  return tableNames.map!(name => name.classify).array;
}

string classify(string tableName) {
  string result; 

  if (result.isEmpty) {
    result = tableName.singularize.camelize;
  }
  return result;
}

