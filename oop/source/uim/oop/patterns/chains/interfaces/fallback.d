module uim.oop.patterns.chains.interfaces.fallback;

import uim.oop;
@safe:

/**
 * Fallback handler interface for default processing.
 */
interface IFallbackHandler : IHandler {
    /**
     * Handles requests that weren't processed by any other handler.
     * Params:
     *   request = The unhandled request
     * Returns: The fallback response
     */
    string handleFallback(string request);
}
