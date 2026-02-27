/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.generic;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic handler interface with typed request and response.
 */
interface IGenericHandler(TRequest, TResponse) {
    /**
     * Sets the next handler in the chain.
     * Params:
     *   handler = The next handler
     * Returns: The next handler for chaining
     */
    IGenericHandler!(TRequest, TResponse) setNext(IGenericHandler!(TRequest, TResponse) handler);
    
    /**
     * Handles the request.
     * Params:
     *   request = The request to handle
     * Returns: The response, or null if not handled
     */
    TResponse handle(TRequest request);
    
    /**
     * Checks if this handler can handle the request.
     * Params:
     *   request = The request to check
     * Returns: true if this handler can process the request
     */
    bool canHandle(TRequest request);
}