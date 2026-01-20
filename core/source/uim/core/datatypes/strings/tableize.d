/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.tableize;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  Returns corresponding table names for given model classnames. (["people", "orders"] for the model classes ["Person", "Order"]).
  
  Params:
    names = The model class names to convert.
  
  Returns:
    The corresponding table names.
  */
string[] tableize(string[] names) {
  return names.map!(name => name.tableize).array;
}
///
unittest {
  auto result = tableize(["Person", "Order", "Main User"]);
  assert(result.length == 3);
  assert(result[0] == "people");
  assert(result[1] == "orders");
  assert(result[2] == "main_users");
}

/** 
  Returns corresponding table name for given model classname. ("people" for the model class "Person").
  
  Params:
    name = The model class name to convert.
  
  Returns:
    The corresponding table name.
  */
string tableize(string name) {
  return name.length > 0 ? name.underscore.pluralize : "";
}
///
unittest {
  assert(tableize("Person") == "people");
  assert(tableize("Order") == "orders");
  assert(tableize("Main User") == "main_users");
}
