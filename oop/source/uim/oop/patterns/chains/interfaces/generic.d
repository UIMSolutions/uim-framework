module uim.oop.patterns.chains.interfaces.generic;

import uim.oop;
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