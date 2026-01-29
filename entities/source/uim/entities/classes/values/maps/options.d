/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.maps.options;

import uim.entities;

mixin(ShowModule!());

@safe:
class Options : MapValue!string {
  // Constructors
  this() { initialize; }

	alias opEquals = UIMValue.opEquals;
}
