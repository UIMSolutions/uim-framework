module uim.oop.patterns.chains.interfaces.request;

import uim.oop;
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