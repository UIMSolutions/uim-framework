/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.maps.config;

import uim.entities;

@safe:
class DxConfigurationValue : DMapValue!string {
  // Constructors
  this() { initialize; }
}
auto ConfigurationValue() { return new DxConfigurationValue; }

///
unittest {
}
