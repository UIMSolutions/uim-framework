/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.factory;

import uim.oop;

mixin(ShowModule!());

@safe:

/** 
  * Factory class for creating instances of `IFormatter`.
  *
  * This factory provides methods to create formatters based on the provided type.
  */
class DFormatterFactory : UIMFactory!(string, IFormatter) {
  this() {
    // Default constructor
    super();
  }

  this(IFormatter delegate() @safe creator) { // Constructor with default creator
    super(creator);
  }
}
