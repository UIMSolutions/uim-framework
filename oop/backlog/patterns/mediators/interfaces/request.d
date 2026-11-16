module uim.oop.patterns.mediators.interfaces.request;

import uim.oop;

mixin(ShowModule!());

@safe:


/**
 * Request-response mediator interface.
 */
interface IRequestResponseMediator {
    /**
     * Sends a request and waits for a response.
     * Params:
     *   requestType = The type of request
     *   requestData = The request data
     * Returns: The response data
     */
    string request(string requestType, string requestData) @safe;
    
    /**
     * Registers a request handler.
     * Params:
     *   requestType = The type of request to handle
     *   handler = The request handler
     */
    void registerHandler(string requestType, string delegate(string requestData) @safe handler) @safe;
}


