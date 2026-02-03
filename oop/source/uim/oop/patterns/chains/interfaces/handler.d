/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.handler;

import uim.oop;
@safe:

/**
 * Handler interface for the Chain of Responsibility pattern.
 * Each handler decides whether to process the request or pass it along the chain.
 */
interface IHandler {
    /**
     * Sets the next handler in the chain.
     * Params:
     *   handler = The next handler
     * Returns: The next handler for chaining
     */
    IHandler setNext(IHandler handler);
    
    /**
     * Handles the request.
     * Params:
     *   request = The request to handle
     * Returns: The result of handling, or null if not handled
     */
    string handle(string request);
}