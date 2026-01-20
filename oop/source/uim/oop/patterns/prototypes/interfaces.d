module uim.oop.patterns.prototypes.interfaces;

import std.traits;

/**
 * Base interface for the Prototype pattern.
 * Objects implementing this interface can be cloned.
 */
interface IPrototype(T) {
    /**
     * Creates and returns a copy of this object.
     * Returns: A new instance that is a copy of this object.
     */
    T clone();
}

/**
 * Interface for objects that support deep cloning.
 * Deep cloning creates a copy of the object and all objects it references.
 */
interface IDeepCloneable(T) : IPrototype!T {
    /**
     * Creates a deep copy of this object.
     * Returns: A new instance with all referenced objects also cloned.
     */
    T deepClone();
}

/**
 * Interface for objects that support shallow cloning.
 * Shallow cloning copies only the object itself, not referenced objects.
 */
interface IShallowCloneable(T) : IPrototype!T {
    /**
     * Creates a shallow copy of this object.
     * Returns: A new instance with references to the same objects.
     */
    T shallowClone();
}

/**
 * Interface for managing a registry of prototype objects.
 */
interface IPrototypeRegistry(T) {
    /**
     * Registers a prototype with a given key.
     * Params:
     *   key = The identifier for the prototype
     *   prototype = The prototype object to register
     */
    void register(string key, T prototype);

    /**
     * Unregisters a prototype by its key.
     * Params:
     *   key = The identifier of the prototype to remove
     */
    void unregister(string key);

    /**
     * Creates a clone of the prototype associated with the given key.
     * Params:
     *   key = The identifier of the prototype to clone
     * Returns: A clone of the registered prototype, or null if not found
     */
    T create(string key);

    /**
     * Checks if a prototype is registered with the given key.
     * Params:
     *   key = The identifier to check
     * Returns: true if the prototype exists, false otherwise
     */
    bool has(string key);

    /**
     * Gets all registered prototype keys.
     * Returns: An array of all registered keys
     */
    string[] keys();

    /**
     * Clears all registered prototypes.
     */
    void clear();
}
