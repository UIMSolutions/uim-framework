/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.helpers.registry;

import uim.commands;

mixin(ShowModule!());

@safe:

// Registry for Commands
class DCommandRegistry : DRegistry!DCommand {
  mixin(RegistryThis!("Command"));
}

mixin(RegistryCalls!("Command"));

unittest {
  auto registry = new DCommandRegistry();
  assert(testRegistry(new DCommandRegistry, "DCommandRegistry"), "Test of DCommandRegistry failed!");
}