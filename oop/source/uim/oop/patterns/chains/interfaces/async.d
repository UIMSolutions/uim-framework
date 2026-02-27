/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.async;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Async handler interface for asynchronous processing.
 */
interface IAsyncHandler {
    /**
     * Sets the next handler in the chain.
     * Params:
     *   handler = The next handler
     * Returns: The next handler for chaining
     */
    IAsyncHandler setNext(IAsyncHandler handler);
    
    /**
     * Handles the request asynchronously.
     * Params:
     *   request = The request to handle
     *   callback = Callback function for the result
     */
    void handleAsync(string request, void delegate(string) callback);
}
