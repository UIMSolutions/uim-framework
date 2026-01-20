/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.interfaces;

import uim.commands;

mixin(ShowModule!());

@safe:

/**
 * Result of a command execution.
 */
struct CommandResult {
  bool success;
  string message;
  Json data;

  /// Create a successful result
  static CommandResult ok(string msg = "", Json resultData = Json(null)) {
    return CommandResult(true, msg, resultData);
  }

  /// Create a failed result
  static CommandResult fail(string msg = "Command execution failed", Json resultData = Json(null)) {
    return CommandResult(false, msg, resultData);
  }

  /// Check if the result is successful
  bool isSuccess() const {
    return success;
  }

  /// Check if the result is a failure
  bool isFailure() const {
    return !success;
  }
}

/**
 * Base interface for all commands.
 * Commands encapsulate business logic and can be executed with parameters.
 */
interface ICommand : IObject {
  /**
   * Execute the command with given options.
   * Params:
   *   options = Command execution parameters
   * Returns: true if execution was successful, false otherwise
   */
  bool execute(Json[string] options = null);

  /**
   * Execute the command and return a detailed result.
   * Params:
   *   options = Command execution parameters
   * Returns: CommandResult with success status, message and optional data
   */
  CommandResult executeWithResult(Json[string] options = null);

  /**
   * Validate command parameters before execution.
   * Params:
   *   options = Parameters to validate
   * Returns: true if parameters are valid, false otherwise
   */
  bool validateParameters(Json[string] options);

  /**
   * Check if the command can be executed with given parameters.
   * Params:
   *   options = Parameters to check
   * Returns: true if command can be executed, false otherwise
   */
  bool canExecute(Json[string] options = null);
}

/**
 * Interface for undoable commands.
 * Implements Command pattern with undo capability.
 */
interface IUndoableCommand : ICommand {
  /**
   * Undo the command's effects.
   * Returns: true if undo was successful, false otherwise
   */
  bool undo();

  /**
   * Check if the command can be undone.
   * Returns: true if undo is possible, false otherwise
   */
  bool canUndo();
}

/**
 * Interface for composite commands.
 * Implements Composite pattern for command grouping.
 */
interface ICompositeCommand : ICommand {
  /**
   * Add a child command.
   * Params:
   *   command = The command to add
   */
  void addCommand(ICommand command);

  /**
   * Remove a child command.
   * Params:
   *   command = The command to remove
   * Returns: true if removed, false if not found
   */
  bool removeCommand(ICommand command);

  /**
   * Get all child commands.
   * Returns: Array of child commands
   */
  ICommand[] getCommands();

  /**
   * Clear all child commands.
   */
  void clearCommands();
}