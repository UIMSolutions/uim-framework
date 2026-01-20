module uim.oop.patterns.mementos.interfaces.generic;

import uim.oop;

mixin(ShowModule!());

@safe:

// Generic memento interface with typed state.
interface IGenericMemento(TState) : IMemento {
    /**
     * Gets the stored state.
     * Returns: The state value
     */
    @safe TState getState() const;
}