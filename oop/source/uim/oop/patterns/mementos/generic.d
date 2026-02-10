module uim.oop.patterns.mementos.generic;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic memento with typed state.
 */
class GenericMemento(TState) : Memento, IGenericMemento!TState {
    private TState _state;
    
    this(string name, TState state) {
        super(name);
        _state = state;
    }
    
    @safe TState getState() const {
        return _state;
    }
}
