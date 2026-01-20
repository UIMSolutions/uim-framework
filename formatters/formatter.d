/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.formatter;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

/** 
  * A basic implementation of the `IFormatter` interface.
  *
  * This class serves as a concrete formatter that can be used directly or extended for more specific formatting needs.
  */
class DFormatter : UIMObject, IFormatter {
  /*    mixin TLocatorAware;
    mixin TLog; */

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  string format(string input, Json[string] options) {
    return input;
  }
}
