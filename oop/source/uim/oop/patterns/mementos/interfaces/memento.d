module uim.oop.patterns.mementos.interfaces.memento;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Memento interface that stores the internal state of an object.
 * The memento is opaque to other objects except the originator.
 */
interface IMemento {
    /**
     * Gets the memento name or identifier.
     * Returns: The memento identifier
     */
    @safe string name() const;
    
    /**
     * Gets the timestamp when the memento was created.
     * Returns: The creation timestamp
     */
    @safe SysTime timestamp() const;
}