module uim.oop.patterns.chains.usecases.supportticketsystem;

import uim.oop;
@safe:
// Real-world example: Support Ticket System

/**
 * Support ticket request.
 */
class SupportTicket {
    private string _issue;
    private int _priority;
    
    this(string issue, int priority) {
        _issue = issue;
        _priority = priority;
    }
    
    string issue() const {
        return _issue;
    }
    
    int priority() const {
        return _priority;
    }
}

/**
 * Level 1 support handler.
 */
class Level1Support : ConditionalHandler {
    override bool shouldHandle(string request) {
        // Handle basic issues
        return request.indexOf("password") >= 0 || 
               request.indexOf("login") >= 0 ||
               request.indexOf("basic") >= 0;
    }
    
    protected override string doHandle(string request) {
        return "Level 1 Support: Handled - " ~ request;
    }
}

/**
 * Level 2 support handler.
 */
class Level2Support : ConditionalHandler {
    override bool shouldHandle(string request) {
        // Handle technical issues
        return request.indexOf("technical") >= 0 || 
               request.indexOf("bug") >= 0 ||
               request.indexOf("error") >= 0;
    }
    
    protected override string doHandle(string request) {
        return "Level 2 Support: Handled - " ~ request;
    }
}

/**
 * Level 3 support handler.
 */
class Level3Support : ConditionalHandler {
    override bool shouldHandle(string request) {
        // Handle critical issues
        return request.indexOf("critical") >= 0 || 
               request.indexOf("emergency") >= 0 ||
               request.indexOf("outage") >= 0;
    }
    
    protected override string doHandle(string request) {
        return "Level 3 Support: Handled - " ~ request;
    }
}

/**
 * Manager escalation handler (fallback).
 */
class ManagerEscalation : BaseHandler, IFallbackHandler {
    override string handle(string request) {
        return handleFallback(request);
    }
    
    string handleFallback(string request) {
        return "Manager: Escalated - " ~ request;
    }
}

unittest {
    mixin(ShowTest!"Support Ticket System Use Case");

    auto level1 = new Level1Support();
    auto level2 = new Level2Support();
    auto level3 = new Level3Support();
    auto manager = new ManagerEscalation();
    
    level1.setNext(level2);
    level2.setNext(level3);
    level3.setNext(manager);
    
    auto result1 = level1.handle("password reset issue");
    assert(result1.indexOf("Level 1") >= 0);
    
    auto result2 = level1.handle("technical bug found");
    assert(result2.indexOf("Level 2") >= 0);
    
    auto result3 = level1.handle("critical system outage");
    assert(result3.indexOf("Level 3") >= 0);
    
    auto result4 = level1.handle("general inquiry");
    assert(result4.indexOf("Manager") >= 0);
}