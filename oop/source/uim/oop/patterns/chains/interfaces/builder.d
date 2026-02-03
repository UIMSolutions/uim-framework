module uim.oop.patterns.chains.interfaces.builder;

import uim.oop;
@safe:

/**
 * Chain builder interface for constructing handler chains.
 */
interface IChainBuilder {
    /**
     * Adds a handler to the chain.
     * Params:
     *   handler = The handler to add
     * Returns: This builder for chaining
     */
    IChainBuilder addHandler(IHandler handler);
    
    /**
     * Builds and returns the chain.
     * Returns: The first handler in the chain
     */
    IHandler build();
}