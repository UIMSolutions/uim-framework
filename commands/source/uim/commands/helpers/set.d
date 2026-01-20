/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.helpers.set;

import uim.commands;

mixin(ShowModule!());

@safe:

class DCommandSet : UIMSet!ICommand {
  mixin(SetThis!("Command"));
}

mixin(SetCalls!("Command"));

unittest {
  auto set = new DCommandSet();
  assert(testSet(set, "CommandSet"), "Test of DCommandSet failed!");
}