module uim.oop.patterns.mementos.caretaker;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Caretaker implementation for managing mementos.
 */
class Caretaker : ICaretaker {
    private IMemento[] _mementos;
    
    @safe void addMemento(IMemento memento) {
        _mementos ~= memento;
    }
    
    @safe IMemento getMemento(size_t index) {
        if (index < _mementos.length) {
            return _mementos[index];
        }
        return null;
    }
    
    @safe size_t count() const {
        return _mementos.length;
    }
    
    @safe void clear() {
        _mementos = [];
    }
}
