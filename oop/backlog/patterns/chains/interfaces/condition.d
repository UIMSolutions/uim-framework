/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.condition;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Conditional handler interface that can filter requests.
 */
interface IConditionalHandler : IHandler {
    /**
     * Checks if this handler should process the request.
     * Params:
     *   request = The request to check
     * Returns: true if this handler should process the request
     */
    bool shouldHandle(string request);
}
