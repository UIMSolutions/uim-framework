/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.coordinator;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Chain coordinator interface for managing multiple chains.
 */
interface IChainCoordinator {
    /**
     * Registers a chain with a name.
     * Params:
     *   name = The chain name
     *   handler = The first handler in the chain
     */
    void registerChain(string name, IHandler handler);
    
    /**
     * Processes a request through a named chain.
     * Params:
     *   chainName = The name of the chain to use
     *   request = The request to process
     * Returns: The response
     */
    string processRequest(string chainName, string request);
    
    /**
     * Checks if a chain is registered.
     * Params:
     *   name = The chain name
     * Returns: true if the chain exists
     */
    bool hasChain(string name) const;
}
