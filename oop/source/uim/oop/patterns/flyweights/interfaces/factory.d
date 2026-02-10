module uim.oop.patterns.flyweights.interfaces.factory;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Flyweight factory interface for managing shared flyweight instances.
 */
interface IFlyweightFactory(T) {
    /**
     * Gets or creates a flyweight with the given key.
     * Params:
     *   key = The intrinsic state identifier
     * Returns: The shared flyweight instance
     */
    T getFlyweight(string key) @safe;
    
    /**
     * Gets the total number of flyweight instances.
     * Returns: The count of unique flyweights
     */
    size_t flyweightCount() const @safe;
    
    /**
     * Lists all flyweight keys.
     * Returns: Array of all registered keys
     */
    string[] listFlyweights() const @safe;
}
