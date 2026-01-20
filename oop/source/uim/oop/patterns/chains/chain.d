/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.chains.chain;

import uim.oop.patterns.chains.interfaces;
import std.format;
import std.algorithm : remove, sort;
import std.conv : to;
import std.string : indexOf;

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

/**
 * Abstract conditional handler with filtering capability.
 */
abstract class ConditionalHandler : BaseHandler, IConditionalHandler {
    override @safe string handle(string request) {
        if (shouldHandle(request)) {
            return doHandle(request);
        }
        return super.handle(request);
    }
    
    abstract @safe bool shouldHandle(string request);
    protected abstract @safe string doHandle(string request);
}

/**
 * Chain builder for constructing handler chains.
 */
class ChainBuilder : IChainBuilder {
    private IHandler[] _handlers;
    
    @safe IChainBuilder addHandler(IHandler handler) {
        _handlers ~= handler;
        return this;
    }
    
    @safe IHandler build() {
        if (_handlers.length == 0) {
            return null;
        }
        
        for (size_t i = 0; i < _handlers.length - 1; i++) {
            _handlers[i].setNext(_handlers[i + 1]);
        }
        
        return _handlers[0];
    }
}

/**
 * Logging handler that tracks request flow.
 */
class LoggingHandler : BaseHandler, ILoggingHandler {
    private string[] _log;
    private string _name;
    
    this(string name) @safe {
        _name = name;
    }
    
    override @safe string handle(string request) {
        _log ~= format("Handler '%s' received: %s", _name, request);
        auto result = super.handle(request);
        if (result !is null) {
            _log ~= format("Handler '%s' result: %s", _name, result);
        }
        return result;
    }
    
    @safe string[] getLog() const {
        return _log.dup;
    }
    
    @safe void clearLog() {
        _log = [];
    }
}

/**
 * Chain coordinator for managing multiple chains.
 */
class ChainCoordinator : IChainCoordinator {
    private IHandler[string] _chains;
    
    @safe void registerChain(string name, IHandler handler) {
        _chains[name] = handler;
    }
    
    @safe string processRequest(string chainName, string request) {
        if (chainName !in _chains) {
            return null;
        }
        return _chains[chainName].handle(request);
    }
    
    @safe bool hasChain(string name) const {
        return (name in _chains) !is null;
    }
}

// Real-world example: Support Ticket System

/**
 * Support ticket request.
 */
class SupportTicket {
    private string _issue;
    private int _priority;
    
    this(string issue, int priority) @safe {
        _issue = issue;
        _priority = priority;
    }
    
    @safe string issue() const {
        return _issue;
    }
    
    @safe int priority() const {
        return _priority;
    }
}

/**
 * Level 1 support handler.
 */
class Level1Support : ConditionalHandler {
    override @safe bool shouldHandle(string request) {
        // Handle basic issues
        return request.indexOf("password") >= 0 || 
               request.indexOf("login") >= 0 ||
               request.indexOf("basic") >= 0;
    }
    
    protected override @safe string doHandle(string request) {
        return "Level 1 Support: Handled - " ~ request;
    }
}

/**
 * Level 2 support handler.
 */
class Level2Support : ConditionalHandler {
    override @safe bool shouldHandle(string request) {
        // Handle technical issues
        return request.indexOf("technical") >= 0 || 
               request.indexOf("bug") >= 0 ||
               request.indexOf("error") >= 0;
    }
    
    protected override @safe string doHandle(string request) {
        return "Level 2 Support: Handled - " ~ request;
    }
}

/**
 * Level 3 support handler.
 */
class Level3Support : ConditionalHandler {
    override @safe bool shouldHandle(string request) {
        // Handle critical issues
        return request.indexOf("critical") >= 0 || 
               request.indexOf("emergency") >= 0 ||
               request.indexOf("outage") >= 0;
    }
    
    protected override @safe string doHandle(string request) {
        return "Level 3 Support: Handled - " ~ request;
    }
}

/**
 * Manager escalation handler (fallback).
 */
class ManagerEscalation : BaseHandler, IFallbackHandler {
    override @safe string handle(string request) {
        return handleFallback(request);
    }
    
    @safe string handleFallback(string request) {
        return "Manager: Escalated - " ~ request;
    }
}

// Real-world example: HTTP Request Processing

/**
 * Authentication handler.
 */
class AuthenticationHandler : ConditionalHandler {
    private string _validToken = "valid-token-123";
    
    override @safe bool shouldHandle(string request) {
        return request.indexOf("auth:") >= 0;
    }
    
    protected override @safe string doHandle(string request) {
        auto authIdx = request.indexOf("auth:");
        if (authIdx >= 0) {
            auto tokenStart = authIdx + 5;
            auto spaceIdx = request.indexOf(" ", tokenStart);
            string token;
            if (spaceIdx > tokenStart) {
                token = request[tokenStart..spaceIdx];
            } else {
                token = request[tokenStart..$];
            }
            if (token == _validToken) {
                return "Authenticated";
            }
        }
        return "Authentication failed";
    }
}

/**
 * Authorization handler.
 */
class AuthorizationHandler : ConditionalHandler {
    override @safe bool shouldHandle(string request) {
        return request.indexOf("role:") >= 0;
    }
    
    protected override @safe string doHandle(string request) {
        auto roleStart = request.indexOf("role:") + 5;
        if (roleStart + 5 <= request.length) {
            auto role = request[roleStart..roleStart+5];
            if (role == "admin") {
                return "Authorized";
            }
        }
        return "Authorization failed";
    }
}

/**
 * Request validation handler.
 */
class ValidationHandler : ConditionalHandler {
    override @safe bool shouldHandle(string request) {
        return request.indexOf("validate:") >= 0;
    }
    
    protected override @safe string doHandle(string request) {
        if (request.length > 20) {
            return "Validated";
        }
        return "Validation failed";
    }
}

/**
 * Request processing handler.
 */
class ProcessingHandler : BaseHandler {
    override @safe string handle(string request) {
        // This handler always processes if reached
        return "Processed: " ~ request;
    }
}

// Real-world example: Purchase Approval

/**
 * Purchase request.
 */
class PurchaseRequest {
    private string _item;
    private double _amount;
    
    this(string item, double amount) @safe {
        _item = item;
        _amount = amount;
    }
    
    @safe string item() const {
        return _item;
    }
    
    @safe double amount() const {
        return _amount;
    }
}

/**
 * Team lead approval handler.
 */
class TeamLeadApproval : BaseHandler {
    private double _approvalLimit = 1000.0;
    
    override @safe string handle(string request) {
        auto amount = parseAmount(request);
        if (amount <= _approvalLimit) {
            return "Team Lead approved: " ~ request;
        }
        return super.handle(request);
    }
    
    private @safe double parseAmount(string request) {
        auto idx = request.indexOf("$");
        if (idx >= 0 && idx + 1 < request.length) {
            try {
                return to!double(request[idx+1..$]);
            } catch (Exception e) {
                return 0.0;
            }
        }
        return 0.0;
    }
}

/**
 * Manager approval handler.
 */
class ManagerApproval : BaseHandler {
    private double _approvalLimit = 5000.0;
    
    override @safe string handle(string request) {
        auto amount = parseAmount(request);
        if (amount <= _approvalLimit) {
            return "Manager approved: " ~ request;
        }
        return super.handle(request);
    }
    
    private @safe double parseAmount(string request) {
        auto idx = request.indexOf("$");
        if (idx >= 0 && idx + 1 < request.length) {
            try {
                return to!double(request[idx+1..$]);
            } catch (Exception e) {
                return 0.0;
            }
        }
        return 0.0;
    }
}

/**
 * Director approval handler.
 */
class DirectorApproval : BaseHandler {
    override @safe string handle(string request) {
        return "Director approved: " ~ request;
    }
}

// Unit tests

@safe unittest {
    // Test basic handler chain
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

@safe unittest {
    // Test chain builder
    class TestHandler : BaseHandler {
        string name;
        this(string n) @safe { name = n; }
        
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

@safe unittest {
    // Test support ticket system
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

@safe unittest {
    // Test HTTP request chain
    auto auth = new AuthenticationHandler();
    auto authz = new AuthorizationHandler();
    auto validation = new ValidationHandler();
    auto processing = new ProcessingHandler();
    
    auth.setNext(authz);
    authz.setNext(validation);
    validation.setNext(processing);
    
    auto result = auth.handle("auth:valid-token-123");
    assert(result == "Authenticated");
}

@safe unittest {
    // Test purchase approval chain
    auto teamLead = new TeamLeadApproval();
    auto manager = new ManagerApproval();
    auto director = new DirectorApproval();
    
    teamLead.setNext(manager);
    manager.setNext(director);
    
    auto result1 = teamLead.handle("Purchase: $500");
    assert(result1.indexOf("Team Lead") >= 0);
    
    auto result2 = teamLead.handle("Purchase: $3000");
    assert(result2.indexOf("Manager") >= 0);
    
    auto result3 = teamLead.handle("Purchase: $10000");
    assert(result3.indexOf("Director") >= 0);
}

@safe unittest {
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

@safe unittest {
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

@safe unittest {
    // Test conditional handler
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
