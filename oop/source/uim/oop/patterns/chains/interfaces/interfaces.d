/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.interfaces;









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
    @safe string process(string request, string delegate(string) @safe next);
}

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
    @safe bool shouldHandle(string request);
}

/**
 * Logging handler interface for tracking request flow.
 */
interface ILoggingHandler : IHandler {
    /**
     * Gets the log entries.
     * Returns: Array of log messages
     */
    @safe string[] getLog() const;
    
    /**
     * Clears the log.
     */
    @safe void clearLog();
}

/**
 * Priority-based handler interface.
 */
interface IPriorityHandler : IHandler {
    /**
     * Gets the handler priority.
     * Returns: The priority level (higher = processed first)
     */
    @safe int priority() const;
}

/**
 * Chain coordinator interface for managing multiple chains.
 */
interface IChainCoordinator {
    /**
     * Registers a chain with a name.
     * Params:
     *   name = The chain name
     *   handler = The first handler in the chain
     */
    @safe void registerChain(string name, IHandler handler);
    
    /**
     * Processes a request through a named chain.
     * Params:
     *   chainName = The name of the chain to use
     *   request = The request to process
     * Returns: The response
     */
    @safe string processRequest(string chainName, string request);
    
    /**
     * Checks if a chain is registered.
     * Params:
     *   name = The chain name
     * Returns: true if the chain exists
     */
    @safe bool hasChain(string name) const;
}

/**
 * Async handler interface for asynchronous processing.
 */
interface IAsyncHandler {
    /**
     * Sets the next handler in the chain.
     * Params:
     *   handler = The next handler
     * Returns: The next handler for chaining
     */
    @safe IAsyncHandler setNext(IAsyncHandler handler);
    
    /**
     * Handles the request asynchronously.
     * Params:
     *   request = The request to handle
     *   callback = Callback function for the result
     */
    @safe void handleAsync(string request, void delegate(string) @safe callback);
}

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
    @safe string handleFallback(string request);
}
