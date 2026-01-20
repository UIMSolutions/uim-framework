/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.tests.test;

import uim.commands;

mixin(Version!"test_uim_oop");

@safe:

bool testCommand(ICommand command, string instanceName) {
  assert(command !is null, "In testCommand: command is null");
  assert(instanceName !is null && instanceName.length > 0, "Instance name is null or empty");
  assert(command.name == instanceName, "In testCommand: command name "~instanceName~" does not match!");

  return true;
}