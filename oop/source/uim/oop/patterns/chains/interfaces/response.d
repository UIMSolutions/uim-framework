module uim.oop.patterns.chains.interfaces.response;

import uim.oop;
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