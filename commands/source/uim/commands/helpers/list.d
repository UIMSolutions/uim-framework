/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.helpers.list;

import uim.commands;

mixin(ShowModule!());

@safe:

class DCommandList : UIMList!ICommand {
  mixin(ListThis!("Command"));
}

mixin(ListCalls!("Command"));

unittest {
  auto list = new DCommandList();
  assert(testList(list, "CommandList"), "Test of DCommandList failed!");
}