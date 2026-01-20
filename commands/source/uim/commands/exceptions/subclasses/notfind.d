/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.exceptions.subclasses.notfind;

import uim.commands;

mixin(Version!"test_uim_oop");

@safe:

// Base commands exception.
class DNotFindCommandException : DCommandException {
  mixin(ExceptionThis!("NotFindCommand"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Could not find command '{name}' in '{instance}'");

    return true;
  }
}

mixin(ExceptionCalls!("NotFindCommand"));

unittest {
  auto exception = new DNotFindCommandException();
  assert(testException(exception), "Test for DNotFindCommandException failed");
}