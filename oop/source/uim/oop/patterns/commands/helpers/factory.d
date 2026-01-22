/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.helpers.factory;

import uim.oop;

mixin(ShowModule!());
@safe:

class DCommandFactory : UIMFactory!(string, ICommand) {
  this() {
    super();
  }

  this(ICommand delegate() @safe creator) { // Constructor with default creator
    super(creator);
  }
}
mixin(FactoryCalls!("Command"));

unittest {
  auto factory = new DCommandFactory();
  assert(testFactory(factory, "Command"), "Test of DCommandFactory failed!");
}
