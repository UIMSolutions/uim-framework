/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.request;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Request interface for chain processing.
 */
interface IRequest {
    /**
     * Gets the request type.
     * Returns: The request type identifier
     */
    string type() const;
    
    /**
     * Gets the request priority.
     * Returns: The priority level (higher = more important)
     */
    int priority() const;
}