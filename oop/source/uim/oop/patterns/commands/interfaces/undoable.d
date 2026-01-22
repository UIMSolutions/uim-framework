/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces.undoable;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Undoable command interface that supports undo operations.
 */
interface IUndoableCommand : ICommand {
    /**
     * Undoes the command execution.
     */
    @safe void undo();
    
    /**
     * Checks if the command can be undone.
     * Returns: true if undo is possible
     */
    @safe bool canUndo() const;
}
