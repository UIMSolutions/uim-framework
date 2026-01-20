/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.flyweights.interfaces;

/**
 * Flyweight interface defines operations that can accept extrinsic state.
 * The flyweight stores intrinsic (shared) state and operates on extrinsic (unique) state.
 */
interface IFlyweight {
    /**
     * Performs an operation using extrinsic state.
     * Params:
     *   extrinsicState = The context-specific state
     * Returns: Result of the operation
     */
    string operation(string extrinsicState) @safe;
}

/**
 * Generic flyweight interface for type-safe operations.
 */
interface IGenericFlyweight(TExtrinsic) {
    /**
     * Performs an operation with typed extrinsic state.
     * Params:
     *   extrinsicState = The context-specific state
     * Returns: Result string
     */
    string operation(TExtrinsic extrinsicState) @safe;
    
    /**
     * Gets the intrinsic state key.
     * Returns: The shared state identifier
     */
    string key() const @safe;
}

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

/**
 * Interface for objects that can report their memory footprint.
 */
interface IMemoryReportable {
    /**
     * Gets an estimate of memory used by this object.
     * Returns: Approximate memory usage in bytes
     */
    size_t memoryUsage() const @safe;
}
