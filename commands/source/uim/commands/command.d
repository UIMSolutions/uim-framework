/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.command;

import uim.commands;

mixin(ShowModule!());

@safe:

/**
 * Abstract base class for commands.
 * Provides common functionality and lifecycle hooks.
 */
abstract class DAbstractCommand : UIMObject, ICommand {
  mixin(CommandThis!());

  protected bool _executed = false;
  protected Json[string] _lastOptions;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  /**
   * Execute command with given options.
   * Template method pattern - calls lifecycle hooks.
   */
  bool execute(Json options) {
    return execute(options.get!(Json[string]));
  }

  bool execute(string[string] options) {
    return execute(options.toJsonMap);
  }
  
  bool execute(Json[string] options = null) {
    _lastOptions = options;
    
    if (!canExecute(options)) {
      return false;
    }

    if (!validateParameters(options)) {
      return false;
    }

    if (!beforeExecute(options)) {
      return false;
    }

    bool result = doExecute(options);
    _executed = result;

    afterExecute(options, result);

    return result;
  }

  /**
   * Execute command and return detailed result.
   */
  CommandResult executeWithResult(Json[string] options = null) {
    bool success = execute(options);
    return success 
      ? CommandResult.ok("Command executed successfully")
      : CommandResult.fail("Command execution failed");
  }

  /**
   * Validate command parameters.
   * Override in subclasses for custom validation.
   */
  bool validateParameters(Json[string] options) {
    return true; // Default: no validation
  }

  /**
   * Check if command can be executed.
   * Override in subclasses for custom checks.
   */
  bool canExecute(Json[string] options = null) {
    return true; // Default: always executable
  }

  /**
   * Core execution logic - must be implemented by subclasses.
   */
  protected abstract bool doExecute(Json[string] options);

  /**
   * Hook called before execution.
   * Override to add pre-execution logic.
   * Returns: true to continue, false to abort
   */
  protected bool beforeExecute(Json[string] options) {
    return true;
  }

  /**
   * Hook called after execution.
   * Override to add post-execution logic.
   */
  protected void afterExecute(Json[string] options, bool success) {
    // Default: no-op
  }

  /**
   * Check if command has been executed.
   */
  bool hasExecuted() const {
    return _executed;
  }

  /**
   * Get the last execution options.
   */
  Json[string] lastOptions() const {
    return cast(Json[string])_lastOptions;
  }
}

/**
 * Base class for commands with standard implementation.
 * For backwards compatibility.
 */
class DCommand : DAbstractCommand {
  mixin(CommandThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  protected override bool doExecute(Json[string] options) {
    // Default implementation for backwards compatibility
    return true;
  }
}

/**
 * Abstract base class for undoable commands.
 * Implements Command pattern with undo capability.
 */
abstract class DUndoableCommand : DAbstractCommand, IUndoableCommand {
  protected bool _canUndo = false;
  protected Json[string] _undoData;

  bool undo() {
    if (!canUndo()) {
      return false;
    }

    if (!beforeUndo()) {
      return false;
    }

    bool result = doUndo();
    
    if (result) {
      _executed = false;
      _canUndo = false;
    }

    afterUndo(result);
    
    return result;
  }

  bool canUndo() {
    return _executed && _canUndo;
  }

  /**
   * Core undo logic - must be implemented by subclasses.
   */
  protected abstract bool doUndo();

  /**
   * Hook called before undo.
   */
  protected bool beforeUndo() {
    return true;
  }

  /**
   * Hook called after undo.
   */
  protected void afterUndo(bool success) {
    // Default: no-op
  }

  protected override void afterExecute(Json[string] options, bool success) {
    super.afterExecute(options, success);
    if (success) {
      _canUndo = true;
      saveUndoData(options);
    }
  }

  /**
   * Save data needed for undo.
   * Override to store command-specific undo information.
   */
  protected void saveUndoData(Json[string] options) {
    _undoData = options.dup;
  }
}

/**
 * Composite command that executes multiple commands in sequence.
 * Implements Composite pattern.
 */
class DCompositeCommand : DAbstractCommand, ICompositeCommand {
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

  bool removeCommand(ICommand command) {
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

  protected override bool doExecute(Json[string] options) {
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
