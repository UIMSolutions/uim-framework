module uim.oop.patterns.chains.classes.builder;

import uim.oop;
@safe:

/**
 * Chain builder for constructing handler chains.
 */
class ChainBuilder : IChainBuilder {
    private IHandler[] _handlers;
    
    IChainBuilder addHandler(IHandler handler) {
        _handlers ~= handler;
        return this;
    }
    
    IHandler build() {
        if (_handlers.length == 0) {
            return null;
        }
        
        for (size_t i = 0; i < _handlers.length - 1; i++) {
            _handlers[i].setNext(_handlers[i + 1]);
        }
        
        return _handlers[0];
    }
}
///
unittest {
    mixin(ShowTest!"Test Chain Builder");

    class TestHandler : BaseHandler {
        string name;
        this(string n) { name = n; }
        
        override string handle(string request) {
            if (request == name) {
                return "Handled by " ~ name;
            }
            return super.handle(request);
        }
    }
    
    auto builder = new ChainBuilder();
    builder.addHandler(new TestHandler("A"));
    builder.addHandler(new TestHandler("B"));
    builder.addHandler(new TestHandler("C"));
    
    auto chain = builder.build();
    assert(chain.handle("A") == "Handled by A");
    assert(chain.handle("B") == "Handled by B");
    assert(chain.handle("C") == "Handled by C");
}