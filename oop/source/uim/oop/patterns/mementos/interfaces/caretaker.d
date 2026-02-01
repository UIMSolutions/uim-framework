/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mementos.interfaces.caretaker;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Caretaker interface that maintains a collection of mementos.
 * The caretaker never examines or modifies the contents of a memento.
 */
interface ICaretaker {
    /**
     * Saves a memento.
     * Params:
     *   memento = The memento to save
     */
    @safe void addMemento(IMemento memento);
    
    /**
     * Gets a memento by index.
     * Params:
     *   index = The index of the memento
     * Returns: The memento at the specified index
     */
    @safe IMemento getMemento(size_t index);
    
    /**
     * Gets the number of stored mementos.
     * Returns: The count of mementos
     */
    @safe size_t count() const;
    
    /**
     * Clears all stored mementos.
     */
    @safe void clear();
}
