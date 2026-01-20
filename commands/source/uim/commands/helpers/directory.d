/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.helpers.directory;

import uim.commands;

mixin(ShowModule!());

@safe:

class DCommandDirectory : DDirectory!ICommand {
  mixin(DirectoryThis!("Command"));
}
mixin(DirectoryCalls!("Command"));

unittest {
  auto directory = new DCommandDirectory();
  assert(testDirectory(directory, "CommandDirectory"), "Test of DCommandDirectory failed!");
}