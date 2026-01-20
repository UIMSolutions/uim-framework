/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.chains;

import uim.oop;
import std.string : indexOf;

// Test 1: Create basic handler
@safe unittest {
    class TestHandler : BaseHandler {
        override string handle(string request) {
            return "handled";
        }
    }
    
    auto handler = new TestHandler();
    assert(handler.handle("test") == "handled");
}

// Test 2: Chain two handlers
@safe unittest {
    class Handler1 : BaseHandler {
        override string handle(string request) {
            if (request == "H1") {
                return "H1 handled";
            }
            return super.handle(request);
        }
    }
    
    class Handler2 : BaseHandler {
        override string handle(string request) {
            if (request == "H2") {
                return "H2 handled";
            }
            return super.handle(request);
        }
    }
    
    auto h1 = new Handler1();
    auto h2 = new Handler2();
    h1.setNext(h2);
    
    assert(h1.handle("H1") == "H1 handled");
    assert(h1.handle("H2") == "H2 handled");
}

// Test 3: Request not handled
@safe unittest {
    class Handler1 : BaseHandler {
        override string handle(string request) {
            if (request == "match") {
                return "handled";
            }
            return super.handle(request);
        }
    }
    
    auto handler = new Handler1();
    assert(handler.handle("no-match") is null);
}

// Test 4: Chain of three handlers
@safe unittest {
    class HandlerA : BaseHandler {
        override string handle(string request) {
            if (request == "A") return "A";
            return super.handle(request);
        }
    }
    
    class HandlerB : BaseHandler {
        override string handle(string request) {
            if (request == "B") return "B";
            return super.handle(request);
        }
    }
    
    class HandlerC : BaseHandler {
        override string handle(string request) {
            if (request == "C") return "C";
            return super.handle(request);
        }
    }
    
    auto a = new HandlerA();
    auto b = new HandlerB();
    auto c = new HandlerC();
    
    a.setNext(b);
    b.setNext(c);
    
    assert(a.handle("A") == "A");
    assert(a.handle("B") == "B");
    assert(a.handle("C") == "C");
    assert(a.handle("D") is null);
}

// Test 5: Chain builder with empty chain
@safe unittest {
    auto builder = new ChainBuilder();
    auto chain = builder.build();
    assert(chain is null);
}

// Test 6: Chain builder with single handler
@safe unittest {
    class SingleHandler : BaseHandler {
        override string handle(string request) {
            return "single";
        }
    }
    
    auto builder = new ChainBuilder();
    builder.addHandler(new SingleHandler());
    
    auto chain = builder.build();
    assert(chain !is null);
    assert(chain.handle("test") == "single");
}

// Test 7: Chain builder with multiple handlers
@safe unittest {
    class NumHandler : BaseHandler {
        int num;
        this(int n) @safe { num = n; }
        
        override string handle(string request) {
            import std.conv : to;
            if (request == to!string(num)) {
                return "Handler " ~ to!string(num);
            }
            return super.handle(request);
        }
    }
    
    auto builder = new ChainBuilder();
    builder.addHandler(new NumHandler(1));
    builder.addHandler(new NumHandler(2));
    builder.addHandler(new NumHandler(3));
    
    auto chain = builder.build();
    assert(chain.handle("1").indexOf("Handler 1") >= 0);
    assert(chain.handle("2").indexOf("Handler 2") >= 0);
    assert(chain.handle("3").indexOf("Handler 3") >= 0);
}

// Test 8: Support ticket Level 1
@safe unittest {
    auto level1 = new Level1Support();
    auto result = level1.handle("password reset needed");
    assert(result !is null);
    assert(result.indexOf("Level 1") >= 0);
}

// Test 9: Support ticket Level 2
@safe unittest {
    auto level1 = new Level1Support();
    auto level2 = new Level2Support();
    level1.setNext(level2);
    
    auto result = level1.handle("technical bug in system");
    assert(result !is null);
    assert(result.indexOf("Level 2") >= 0);
}

// Test 10: Support ticket Level 3
@safe unittest {
    auto level1 = new Level1Support();
    auto level2 = new Level2Support();
    auto level3 = new Level3Support();
    
    level1.setNext(level2);
    level2.setNext(level3);
    
    auto result = level1.handle("critical system down");
    assert(result !is null);
    assert(result.indexOf("Level 3") >= 0);
}

// Test 11: Support ticket escalation to manager
@safe unittest {
    auto level1 = new Level1Support();
    auto level2 = new Level2Support();
    auto level3 = new Level3Support();
    auto manager = new ManagerEscalation();
    
    level1.setNext(level2);
    level2.setNext(level3);
    level3.setNext(manager);
    
    auto result = level1.handle("general question");
    assert(result !is null);
    assert(result.indexOf("Manager") >= 0);
}

// Test 12: Authentication handler
@safe unittest {
    auto auth = new AuthenticationHandler();
    auto result = auth.handle("auth:valid-token-123");
    assert(result == "Authenticated");
}

// Test 13: Authentication failure
@safe unittest {
    auto auth = new AuthenticationHandler();
    auto result = auth.handle("auth:invalid-token-");
    assert(result == "Authentication failed");
}

// Test 14: Authorization handler
@safe unittest {
    auto authz = new AuthorizationHandler();
    auto result = authz.handle("role:admin");
    assert(result == "Authorized");
}

// Test 15: Authorization failure
@safe unittest {
    auto authz = new AuthorizationHandler();
    auto result = authz.handle("role:guest");
    assert(result == "Authorization failed");
}

// Test 16: Validation handler
@safe unittest {
    auto validator = new ValidationHandler();
    auto result = validator.handle("validate:this-is-a-long-request-string");
    assert(result == "Validated");
}

// Test 17: HTTP request processing chain
@safe unittest {
    auto auth = new AuthenticationHandler();
    auto authz = new AuthorizationHandler();
    auto validator = new ValidationHandler();
    auto processor = new ProcessingHandler();
    
    auth.setNext(authz);
    authz.setNext(validator);
    validator.setNext(processor);
    
    // Test authentication
    auto result1 = auth.handle("auth:valid-token-123");
    assert(result1 == "Authenticated");
    
    // Test request without auth
    auto result2 = auth.handle("some request data");
    assert(result2.indexOf("Processed") >= 0);
}

// Test 18: Purchase approval by team lead
@safe unittest {
    auto teamLead = new TeamLeadApproval();
    auto result = teamLead.handle("Purchase: $500");
    assert(result.indexOf("Team Lead") >= 0);
}

// Test 19: Purchase approval by manager
@safe unittest {
    auto teamLead = new TeamLeadApproval();
    auto manager = new ManagerApproval();
    teamLead.setNext(manager);
    
    auto result = teamLead.handle("Purchase: $3000");
    assert(result.indexOf("Manager") >= 0);
}

// Test 20: Purchase approval by director
@safe unittest {
    auto teamLead = new TeamLeadApproval();
    auto manager = new ManagerApproval();
    auto director = new DirectorApproval();
    
    teamLead.setNext(manager);
    manager.setNext(director);
    
    auto result = teamLead.handle("Purchase: $10000");
    assert(result.indexOf("Director") >= 0);
}

// Test 21: Logging handler tracks requests
@safe unittest {
    class SimpleHandler : BaseHandler {
        override string handle(string request) {
            return "done";
        }
    }
    
    auto logger = new LoggingHandler("TestLogger");
    auto handler = new SimpleHandler();
    logger.setNext(handler);
    
    logger.handle("test request");
    auto log = logger.getLog();
    
    assert(log.length > 0);
    assert(log[0].indexOf("TestLogger") >= 0);
    assert(log[0].indexOf("test request") >= 0);
}

// Test 22: Logging handler clear log
@safe unittest {
    auto logger = new LoggingHandler("Logger");
    logger.handle("test");
    
    assert(logger.getLog().length > 0);
    
    logger.clearLog();
    assert(logger.getLog().length == 0);
}

// Test 23: Chain coordinator register chain
@safe unittest {
    class TestChain : BaseHandler {
        override string handle(string request) {
            return "handled";
        }
    }
    
    auto coordinator = new ChainCoordinator();
    coordinator.registerChain("test", new TestChain());
    
    assert(coordinator.hasChain("test"));
    assert(!coordinator.hasChain("nonexistent"));
}

// Test 24: Chain coordinator process request
@safe unittest {
    class ChainA : BaseHandler {
        override string handle(string request) {
            return "Chain A: " ~ request;
        }
    }
    
    class ChainB : BaseHandler {
        override string handle(string request) {
            return "Chain B: " ~ request;
        }
    }
    
    auto coordinator = new ChainCoordinator();
    coordinator.registerChain("A", new ChainA());
    coordinator.registerChain("B", new ChainB());
    
    auto resultA = coordinator.processRequest("A", "test");
    assert(resultA.indexOf("Chain A") >= 0);
    
    auto resultB = coordinator.processRequest("B", "test");
    assert(resultB.indexOf("Chain B") >= 0);
}

// Test 25: Chain coordinator with nonexistent chain
@safe unittest {
    auto coordinator = new ChainCoordinator();
    auto result = coordinator.processRequest("nonexistent", "test");
    assert(result is null);
}

// Test 26: Conditional handler
@safe unittest {
    class EvenHandler : ConditionalHandler {
        override bool shouldHandle(string request) {
            import std.conv : to;
            try {
                auto num = to!int(request);
                return num % 2 == 0;
            } catch (Exception e) {
                return false;
            }
        }
        
        protected override string doHandle(string request) {
            return "Even";
        }
    }
    
    auto handler = new EvenHandler();
    assert(handler.handle("2") == "Even");
    assert(handler.handle("4") == "Even");
    assert(handler.handle("3") is null);
}

// Test 27: Conditional handler chain
@safe unittest {
    class PositiveHandler : ConditionalHandler {
        override bool shouldHandle(string request) {
            import std.conv : to;
            try {
                return to!int(request) > 0;
            } catch (Exception e) {
                return false;
            }
        }
        
        protected override string doHandle(string request) {
            return "Positive";
        }
    }
    
    class NegativeHandler : ConditionalHandler {
        override bool shouldHandle(string request) {
            import std.conv : to;
            try {
                return to!int(request) < 0;
            } catch (Exception e) {
                return false;
            }
        }
        
        protected override string doHandle(string request) {
            return "Negative";
        }
    }
    
    auto pos = new PositiveHandler();
    auto neg = new NegativeHandler();
    pos.setNext(neg);
    
    assert(pos.handle("5") == "Positive");
    assert(pos.handle("-5") == "Negative");
}

// Test 28: Manager escalation fallback
@safe unittest {
    auto manager = new ManagerEscalation();
    auto result = manager.handleFallback("unhandled issue");
    assert(result.indexOf("Manager") >= 0);
    assert(result.indexOf("Escalated") >= 0);
}

// Test 29: Builder fluent interface
@safe unittest {
    class H1 : BaseHandler {
        override string handle(string request) {
            if (request == "1") return "H1";
            return super.handle(request);
        }
    }
    
    class H2 : BaseHandler {
        override string handle(string request) {
            if (request == "2") return "H2";
            return super.handle(request);
        }
    }
    
    auto builder = new ChainBuilder();
    auto chain = builder
        .addHandler(new H1())
        .addHandler(new H2())
        .build();
    
    assert(chain.handle("1") == "H1");
    assert(chain.handle("2") == "H2");
}

// Test 30: Complex support chain
@safe unittest {
    auto level1 = new Level1Support();
    auto level2 = new Level2Support();
    auto level3 = new Level3Support();
    auto manager = new ManagerEscalation();
    
    level1.setNext(level2);
    level2.setNext(level3);
    level3.setNext(manager);
    
    // Test various ticket types
    auto r1 = level1.handle("basic password issue");
    assert(r1.indexOf("Level 1") >= 0);
    
    auto r2 = level1.handle("technical error code 500");
    assert(r2.indexOf("Level 2") >= 0);
    
    auto r3 = level1.handle("critical server outage");
    assert(r3.indexOf("Level 3") >= 0);
    
    auto r4 = level1.handle("billing question");
    assert(r4.indexOf("Manager") >= 0);
}

// Test 31: Multiple chains with coordinator
@safe unittest {
    class SupportChain : BaseHandler {
        override string handle(string request) {
            return "Support: " ~ request;
        }
    }
    
    class SalesChain : BaseHandler {
        override string handle(string request) {
            return "Sales: " ~ request;
        }
    }
    
    class TechChain : BaseHandler {
        override string handle(string request) {
            return "Tech: " ~ request;
        }
    }
    
    auto coordinator = new ChainCoordinator();
    coordinator.registerChain("support", new SupportChain());
    coordinator.registerChain("sales", new SalesChain());
    coordinator.registerChain("tech", new TechChain());
    
    assert(coordinator.processRequest("support", "help").indexOf("Support") >= 0);
    assert(coordinator.processRequest("sales", "buy").indexOf("Sales") >= 0);
    assert(coordinator.processRequest("tech", "fix").indexOf("Tech") >= 0);
}

// Test 32: Purchase with exact limit
@safe unittest {
    auto teamLead = new TeamLeadApproval();
    auto manager = new ManagerApproval();
    teamLead.setNext(manager);
    
    // Exact limit for team lead
    auto result1 = teamLead.handle("Purchase: $1000");
    assert(result1.indexOf("Team Lead") >= 0);
    
    // Just over team lead limit
    auto result2 = teamLead.handle("Purchase: $1001");
    assert(result2.indexOf("Manager") >= 0);
}

// Test 33: Handler returning null propagates
@safe unittest {
    class Handler1 : BaseHandler {
        override string handle(string request) {
            // Always passes to next
            return super.handle(request);
        }
    }
    
    class Handler2 : BaseHandler {
        override string handle(string request) {
            // Also passes to next
            return super.handle(request);
        }
    }
    
    auto h1 = new Handler1();
    auto h2 = new Handler2();
    h1.setNext(h2);
    
    // Should return null as no handler processes it
    assert(h1.handle("test") is null);
}

// Test 34: Logging multiple requests
@safe unittest {
    auto logger = new LoggingHandler("Multi");
    auto processor = new ProcessingHandler();
    logger.setNext(processor);
    
    logger.handle("request1");
    logger.handle("request2");
    logger.handle("request3");
    
    auto log = logger.getLog();
    assert(log.length >= 3);
}

// Test 35: Chain builder preserves handler order
@safe unittest {
    class OrderHandler : BaseHandler {
        int order;
        static int lastProcessed = 0;
        
        this(int o) @safe { order = o; }
        
        override string handle(string request) {
            lastProcessed = order;
            return super.handle(request);
        }
    }
    
    OrderHandler.lastProcessed = 0;
    
    auto builder = new ChainBuilder();
    builder.addHandler(new OrderHandler(1));
    builder.addHandler(new OrderHandler(2));
    builder.addHandler(new OrderHandler(3));
    
    auto chain = builder.build();
    chain.handle("test");
    
    // Last handler should be 3 (they all pass to next)
    assert(OrderHandler.lastProcessed == 3);
}
