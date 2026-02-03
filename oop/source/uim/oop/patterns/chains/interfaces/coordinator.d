module uim.oop.patterns.chains.interfaces.coordinator;

import uim.oop;
@safe:
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
    void registerChain(string name, IHandler handler);
    
    /**
     * Processes a request through a named chain.
     * Params:
     *   chainName = The name of the chain to use
     *   request = The request to process
     * Returns: The response
     */
    string processRequest(string chainName, string request);
    
    /**
     * Checks if a chain is registered.
     * Params:
     *   name = The chain name
     * Returns: true if the chain exists
     */
    bool hasChain(string name) const;
}
