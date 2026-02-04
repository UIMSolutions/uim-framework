module uim.oop.patterns.chains.classes.condition;
import uim.oop;
@safe:
/**
 * Abstract conditional handler with filtering capability.
 */
abstract class ConditionalHandler : BaseHandler, IConditionalHandler {
    override string handle(string request) {
        if (shouldHandle(request)) {
            return doHandle(request);
        }
        return super.handle(request);
    }
    
    abstract bool shouldHandle(string request);
    protected abstract string doHandle(string request);
}
///
unittest {
    mixin(ShowTest!"Test conditional handler");
    
    class EvenHandler : ConditionalHandler {
        override bool shouldHandle(string request) {
            try {
                auto num = to!int(request);
                return num % 2 == 0;
            } catch (Exception e) {
                return false;
            }
        }
        
        protected override string doHandle(string request) {
            return "Even: " ~ request;
        }
    }
    
    class OddHandler : ConditionalHandler {
        override bool shouldHandle(string request) {
            try {
                auto num = to!int(request);
                return num % 2 == 1;
            } catch (Exception e) {
                return false;
            }
        }
        
        protected override string doHandle(string request) {
            return "Odd: " ~ request;
        }
    }
    
    auto even = new EvenHandler();
    auto odd = new OddHandler();
    even.setNext(odd);
    
    auto result1 = even.handle("4");
    assert(result1.indexOf("Even") >= 0);
    
    auto result2 = even.handle("5");
    assert(result2.indexOf("Odd") >= 0);
}
