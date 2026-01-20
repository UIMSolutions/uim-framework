/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.helpers.factory;

import uim.commands;

mixin(ShowModule!());
@safe:

class DCommandFactory : DFactory!ICommand {
  mixin(FactoryThis!("Command"));
}
mixin(FactoryCalls!("Command"));

unittest {
  auto factory = new DCommandFactory();
  assert(testFactory(factory, "Command"), "Test of DCommandFactory failed!");
}
