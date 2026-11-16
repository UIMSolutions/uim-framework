module uim.oop.patterns.mementos.interfaces.history;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * History manager interface for managing undo/redo with mementos.
 */
interface IHistoryManager {
    /**
     * Saves the current state.
     */
    @safe void backup();
    
    /**
     * Undoes the last change.
     * Returns: true if undo was successful
     */
    @safe bool undo();
    
    /**
     * Checks if undo is available.
     * Returns: true if undo is possible
     */
    @safe bool canUndo() const;
    
    /**
     * Gets the number of available undo steps.
     * Returns: The undo count
     */
    @safe size_t undoCount() const;
}