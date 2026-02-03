module uim.oop.patterns.chains.interfaces.middleware;

import uim.oop;
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