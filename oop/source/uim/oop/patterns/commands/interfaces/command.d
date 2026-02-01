/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces.command;

import uim.oop;

mixin(ShowModule!());

@safe:

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
  bool validateParameters(Json[string] options = null);

  /**
   * Check if the command can be executed with given parameters.
   * Params:
   *   options = Parameters to check
   * Returns: true if command can be executed, false otherwise
   */
  bool canExecute(Json[string] options = null);
}