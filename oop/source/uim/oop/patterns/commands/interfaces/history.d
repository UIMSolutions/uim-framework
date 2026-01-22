module uim.oop.patterns.commands.interfaces.history;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Command history interface for tracking executed commands.
 */
interface ICommandHistory {
    /**
     * Adds a command to the history.
     * Params:
     *   command = The command to record
     */
    @safe void record(IUndoableCommand command);
    
    /**
     * Undoes the last command.
     * Returns: true if undo was successful
     */
    @safe bool undo();
    
    /**
     * Redoes the last undone command.
     * Returns: true if redo was successful
     */
    @safe bool redo();
    
    /**
     * Checks if undo is available.
     * Returns: true if there are commands to undo
     */
    @safe bool canUndo() const;
    
    /**
     * Checks if redo is available.
     * Returns: true if there are commands to redo
     */
    @safe bool canRedo() const;
    
    /**
     * Clears the command history.
     */
    @safe void clear();
}