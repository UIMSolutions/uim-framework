/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.flyweights.interfaces.flyweight;

import uim.oop;

mixin(ShowModule!());

@safe:

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