module uim.oop.patterns.chains.interfaces.condition;

import uim.oop;
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
