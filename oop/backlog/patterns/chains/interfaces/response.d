/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.response;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Response interface for chain processing results.
 */
interface IResponse {
    /**
     * Checks if the request was handled successfully.
     * Returns: true if handled successfully
     */
    bool isHandled() const;
    
    /**
     * Gets the handler that processed the request.
     * Returns: The handler name
     */
    string handledBy() const;
    
    /**
     * Gets the response message.
     * Returns: The response message
     */
    string message() const;
}