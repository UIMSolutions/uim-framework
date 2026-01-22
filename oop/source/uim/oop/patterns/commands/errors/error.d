/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.errors.error;

import uim.oop;

mixin(ShowModule!());

@safe:

// Base commands exception.
/* 
class DCommandException : DException {
  mixin(ExceptionThis!("Command"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in uim.oop.patterns.commands");

    return true;
  }
}

mixin(ExceptionCalls!("Command"));

unittest {
  auto exception = new DCommandException();
  assert(exception !is null, "Failed to create DCommandException instance");

  assert(testException(exception), "Test for DCommandException failed");
}
*/