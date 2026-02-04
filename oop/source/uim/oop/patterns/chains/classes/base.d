module uim.oop.patterns.chains.classes.base;
import uim.oop;
@safe:
/**
 * Abstract base handler implementing the chain mechanism.
 */
abstract class BaseHandler : IHandler {
    protected IHandler _nextHandler;
    
    @safe IHandler setNext(IHandler handler) {
        _nextHandler = handler;
        return handler;
    }
    
    @safe string handle(string request) {
        if (_nextHandler !is null) {
            return _nextHandler.handle(request);
        }
        return null;
    }
}
///
unittest {
    mixin(ShowTest!"Test basic handler chain");
    
    class Handler1 : BaseHandler {
        override string handle(string request) {
            if (request == "H1") {
                return "Handled by H1";
            }
            return super.handle(request);
        }
    }
    
    class Handler2 : BaseHandler {
        override string handle(string request) {
            if (request == "H2") {
                return "Handled by H2";
            }
            return super.handle(request);
        }
    }
    
    auto h1 = new Handler1();
    auto h2 = new Handler2();
    h1.setNext(h2);
    
    assert(h1.handle("H1") == "Handled by H1");
    assert(h1.handle("H2") == "Handled by H2");
    assert(h1.handle("H3") is null);
}
