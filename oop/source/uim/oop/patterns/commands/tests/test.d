/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

bool testCommand(ICommand command, string commandName) {
  assert(command !is null, "In testCommand: command is null");
  assert(commandName !is null && commandName.length > 0, "Instance name is null or empty");
  // assert(command.name == commandName, "In testCommand: command name "~commandName~" does not match!");

  return true;
}