/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.middleware;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Middleware handler interface with before/after hooks.
 */
interface IMiddleware {
    /**
     * Processes the request before passing to the next handler.
     * Params:
     *   request = The request to process
     *   next = The next handler function
     * Returns: The response
     */
    string process(string request, string delegate(string) next);
}