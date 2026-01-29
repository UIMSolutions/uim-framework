/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.composite;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Composite command that executes multiple commands in sequence.
 * Implements Composite pattern.
 */
class CompositeCommand : DAbstractCommand, ICompositeCommand {
  mixin(CommandThis!());

  protected ICommand[] _commands;
  protected bool _stopOnError = true;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto stopOnError = "stopOnError" in initData) {
      _stopOnError = stopOnError.get!bool;
    }

    return true;
  }

  void addCommand(ICommand command) {
    if (command !is null) {
      _commands ~= command;
    }
  }

  bool removeCommand(ICommand command) @trusted {
    import std.algorithm : remove, countUntil;
    
    auto index = _commands.countUntil(command);
    if (index >= 0) {
      _commands = _commands.remove(index);
      return true;
    }
    return false;
  }

  ICommand[] getCommands() {
    return _commands.dup;
  }

  void clearCommands() {
    _commands = [];
  }

  protected override bool doExecute(Json[string] options = null) {
    bool allSuccess = true;
    
    foreach (command; _commands) {
      bool result = command.execute(options);
      
      if (!result) {
        allSuccess = false;
        if (_stopOnError) {
          break;
        }
      }
    }
    
    return allSuccess;
  }

  override CommandResult executeWithResult(Json[string] options = null) {
    int totalCommands = cast(int)_commands.length;
    int successCount = 0;
    
    foreach (command; _commands) {
      if (command.execute(options)) {
        successCount++;
      } else if (_stopOnError) {
        break;
      }
    }
    
    bool success = successCount == totalCommands;
    string message = success 
      ? "All commands executed successfully"
      : "Executed " ~ successCount.to!string ~ " of " ~ totalCommands.to!string ~ " commands";
    
    auto data = Json.emptyObject;
    data["totalCommands"] = totalCommands;
    data["successCount"] = successCount;
    
    return CommandResult(success, message, data);
  }
}
