/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.builder;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Chain builder interface for constructing handler chains.
 */
interface IChainBuilder {
    /**
     * Adds a handler to the chain.
     * Params:
     *   handler = The handler to add
     * Returns: This builder for chaining
     */
    IChainBuilder addHandler(IHandler handler);
    
    /**
     * Builds and returns the chain.
     * Returns: The first handler in the chain
     */
    IHandler build();
}