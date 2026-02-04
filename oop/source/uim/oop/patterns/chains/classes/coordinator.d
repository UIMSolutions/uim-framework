module uim.oop.patterns.chains.classes.coordinator;
import uim.oop;
@safe:
/**
 * Chain coordinator for managing multiple chains.
 */
class ChainCoordinator : IChainCoordinator {
    private IHandler[string] _chains;
    
    void registerChain(string name, IHandler handler) {
        _chains[name] = handler;
    }
    
    string processRequest(string chainName, string request) {
        if (chainName !in _chains) {
            return null;
        }
        return _chains[chainName].handle(request);
    }
    
    bool hasChain(string name) const {
        return (name in _chains) !is null;
    }
}
///
unittest {
    // Test chain coordinator
    class ChainAHandler : BaseHandler {
        override string handle(string request) {
            return "Chain A: " ~ request;
        }
    }
    
    class ChainBHandler : BaseHandler {
        override string handle(string request) {
            return "Chain B: " ~ request;
        }
    }
    
    auto coordinator = new ChainCoordinator();
    coordinator.registerChain("A", new ChainAHandler());
    coordinator.registerChain("B", new ChainBHandler());
    
    assert(coordinator.hasChain("A"));
    assert(coordinator.hasChain("B"));
    assert(!coordinator.hasChain("C"));
    
    auto resultA = coordinator.processRequest("A", "test");
    assert(resultA.indexOf("Chain A") >= 0);
    
    auto resultB = coordinator.processRequest("B", "test");
    assert(resultB.indexOf("Chain B") >= 0);
}