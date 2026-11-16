/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces.composite;

import uim.oop;

mixin(ShowModule!());

@safe:
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
