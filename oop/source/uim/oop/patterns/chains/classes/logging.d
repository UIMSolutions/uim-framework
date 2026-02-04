module uim.oop.patterns.chains.classes.logging;
import uim.oop;
@safe:
/**
 * Logging handler that tracks request flow.
 */
class LoggingHandler : BaseHandler, ILoggingHandler {
    private string[] _log;
    private string _name;
    
    this(string name) {
        _name = name;
    }
    
    override string handle(string request) {
        _log ~= format("Handler '%s' received: %s", _name, request);
        auto result = super.handle(request);
        if (result !is null) {
            _log ~= format("Handler '%s' result: %s", _name, result);
        }
        return result;
    }
    
    string[] getLog() const {
        return _log.dup;
    }
    
    void clearLog() {
        _log = [];
    }
}
///
unittest {
    // Test logging handler
    class SimpleHandler : BaseHandler {
        override string handle(string request) {
            if (request == "test") {
                return "handled";
            }
            return super.handle(request);
        }
    }
    
    auto logger = new LoggingHandler("Logger");
    auto handler = new SimpleHandler();
    logger.setNext(handler);
    
    logger.handle("test");
    auto log = logger.getLog();
    assert(log.length > 0);
    assert(log[0].indexOf("Logger") >= 0);
    
    logger.clearLog();
    assert(logger.getLog().length == 0);
}