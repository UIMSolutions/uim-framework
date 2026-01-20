module uim.oop.patterns.mementos.interfaces.originator;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Originator interface for objects that can create and restore mementos.
 * The originator creates a memento containing a snapshot of its current state
 * and uses it to restore its state later.
 */
interface IOriginator {
    /**
     * Creates a memento containing the current state.
     * Returns: A new memento with the current state
     */
    @safe IMemento save();
    
    /**
     * Restores the originator's state from a memento.
     * Params:
     *   memento = The memento to restore from
     */
    @safe void restore(IMemento memento);
}