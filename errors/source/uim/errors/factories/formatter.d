/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.factories.formatter;

import uim.errors;

mixin(ShowModule!());

@safe:

class UIMErrorFormatterFactory : UIMFactory!(string, UIMErrorFormatter) {
  this() {
    super(() => new UIMErrorFormatter());
  }

  private static UIMErrorFormatterFactory _instance;
  static UIMErrorFormatterFactory instance() {
    if (_instance is null) {
      _instance = new UIMErrorFormatterFactory();
    }
    return _instance;
  }
}

auto ErrorFormatterFactory() {
  return UIMErrorFormatterFactory.instance;
}
