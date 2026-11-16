/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.undoable;

import uim.oop;

mixin(ShowModule!());

@safe:
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
  protected void saveUndoData(Json[string] options = null) {
    _undoData = options.dup;
  }
}