/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.flyweights.interfaces.generic;

import uim.oop;

mixin(ShowModule!());

@safe:
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