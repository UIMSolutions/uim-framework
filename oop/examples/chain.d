/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.chain;

import uim.oop;
import std.stdio;
import std.string : indexOf;

void main() {
    writeln("\n=== Chain of Responsibility Pattern Examples ===\n");
    
    example1_BasicChain();
    example2_SupportTicketSystem();
    example3_PurchaseApproval();
    example4_HTTPRequestPipeline();
    example5_LoggingChain();
    example6_ChainBuilder();
    example7_ChainCoordinator();
    example8_ComplexEscalation();
}

/// Example 1: Basic Handler Chain
void example1_BasicChain() {
    writeln("--- Example 1: Basic Handler Chain ---");
    
    class HandlerA : BaseHandler {
        override string handle(string request) {
            writeln("HandlerA received: ", request);
            if (request == "A") {
                return "HandlerA processed";
            }
            writeln("HandlerA passing to next handler");
            return super.handle(request);
        }
    }
    
    class HandlerB : BaseHandler {
        override string handle(string request) {
            writeln("HandlerB received: ", request);
            if (request == "B") {
                return "HandlerB processed";
            }
            writeln("HandlerB passing to next handler");
            return super.handle(request);
        }
    }
    
    class HandlerC : BaseHandler {
        override string handle(string request) {
            writeln("HandlerC received: ", request);
            return "HandlerC processed (default)";
        }
    }
    
    auto handlerA = new HandlerA();
    auto handlerB = new HandlerB();
    auto handlerC = new HandlerC();
    
    handlerA.setNext(handlerB).setNext(handlerC);
    
    writeln("\nRequest: A");
    writeln("Result: ", handlerA.handle("A"));
    
    writeln("\nRequest: B");
    writeln("Result: ", handlerA.handle("B"));
    
    writeln("\nRequest: X");
    writeln("Result: ", handlerA.handle("X"));
    
    writeln();
}

/// Example 2: Support Ticket System
void example2_SupportTicketSystem() {
    writeln("--- Example 2: Support Ticket System ---");
    
    auto level1 = new Level1Support();
    auto level2 = new Level2Support();
    auto level3 = new Level3Support();
    auto manager = new ManagerEscalation();
    
    level1.setNext(level2).setNext(level3).setNext(manager);
    
    string[] tickets = [
        "password reset required",
        "technical bug in payment system",
        "critical server outage",
        "general inquiry about features"
    ];
    
    foreach (ticket; tickets) {
        writeln("\nTicket: ", ticket);
        auto result = level1.handle(ticket);
        writeln("Response: ", result);
    }
    
    writeln();
}

/// Example 3: Purchase Approval Workflow
void example3_PurchaseApproval() {
    writeln("--- Example 3: Purchase Approval Workflow ---");
    
    auto teamLead = new TeamLeadApproval();
    auto manager = new ManagerApproval();
    auto director = new DirectorApproval();
    
    teamLead.setNext(manager).setNext(director);
    
    struct Purchase {
        string item;
        double amount;
    }
    
    Purchase[] purchases = [
        Purchase("Office supplies", 500),
        Purchase("New laptop", 2500),
        Purchase("Server equipment", 15000)
    ];
    
    foreach (purchase; purchases) {
        import std.format : format;
        auto request = format("Purchase: $%.2f", purchase.amount);
        writeln("\nRequest: ", purchase.item, " - $", purchase.amount);
        auto result = teamLead.handle(request);
        writeln("Decision: ", result);
    }
    
    writeln();
}

/// Example 4: HTTP Request Pipeline
void example4_HTTPRequestPipeline() {
    writeln("--- Example 4: HTTP Request Pipeline ---");
    
    auto auth = new AuthenticationHandler();
    auto authz = new AuthorizationHandler();
    auto validator = new ValidationHandler();
    auto processor = new ProcessingHandler();
    
    auth.setNext(authz).setNext(validator).setNext(processor);
    
    writeln("Request 1: Authentication check");
    auto r1 = auth.handle("auth:valid-token-123");
    writeln("Result: ", r1);
    
    writeln("\nRequest 2: Authorization check");
    auto r2 = auth.handle("role:admin");
    writeln("Result: ", r2);
    
    writeln("\nRequest 3: Validation");
    auto r3 = auth.handle("validate:some-long-data-string-here");
    writeln("Result: ", r3);
    
    writeln("\nRequest 4: Regular processing");
    auto r4 = auth.handle("GET /api/users");
    writeln("Result: ", r4);
    
    writeln();
}

/// Example 5: Logging Chain
void example5_LoggingChain() {
    writeln("--- Example 5: Logging Chain ---");
    
    class DataValidator : BaseHandler {
        override string handle(string request) {
            if (request.length < 5) {
                return "Validation failed: too short";
            }
            return super.handle(request);
        }
    }
    
    class DataProcessor : BaseHandler {
        override string handle(string request) {
            return "Processed: " ~ request;
        }
    }
    
    auto logger = new LoggingHandler("RequestLogger");
    auto validator = new DataValidator();
    auto processor = new DataProcessor();
    
    logger.setNext(validator).setNext(processor);
    
    writeln("Processing request: 'valid data'");
    auto result = logger.handle("valid data");
    writeln("Result: ", result);
    
    writeln("\nLog entries:");
    foreach (entry; logger.getLog()) {
        writeln("  ", entry);
    }
    
    writeln();
}

/// Example 6: Chain Builder
void example6_ChainBuilder() {
    writeln("--- Example 6: Chain Builder ---");
    
    class NumberHandler : BaseHandler {
        int number;
        
        this(int n) @safe {
            number = n;
        }
        
        override string handle(string request) {
            import std.conv : to;
            try {
                auto num = to!int(request);
                if (num == number) {
                    return "Handled by handler " ~ to!string(number);
                }
            } catch (Exception e) {
                // Not a number
            }
            return super.handle(request);
        }
    }
    
    writeln("Building a chain with ChainBuilder:");
    auto builder = new ChainBuilder();
    builder
        .addHandler(new NumberHandler(1))
        .addHandler(new NumberHandler(2))
        .addHandler(new NumberHandler(3))
        .addHandler(new NumberHandler(4))
        .addHandler(new NumberHandler(5));
    
    auto chain = builder.build();
    
    writeln("\nTesting requests:");
    for (int i = 1; i <= 6; i++) {
        import std.conv : to;
        auto result = chain.handle(to!string(i));
        writeln("Request ", i, ": ", result is null ? "Not handled" : result);
    }
    
    writeln();
}

/// Example 7: Chain Coordinator
void example7_ChainCoordinator() {
    writeln("--- Example 7: Chain Coordinator ---");
    
    class SupportHandler : BaseHandler {
        override string handle(string request) {
            return "Support team will assist with: " ~ request;
        }
    }
    
    class SalesHandler : BaseHandler {
        override string handle(string request) {
            return "Sales team will handle: " ~ request;
        }
    }
    
    class TechnicalHandler : BaseHandler {
        override string handle(string request) {
            return "Technical team will resolve: " ~ request;
        }
    }
    
    auto coordinator = new ChainCoordinator();
    coordinator.registerChain("support", new SupportHandler());
    coordinator.registerChain("sales", new SalesHandler());
    coordinator.registerChain("technical", new TechnicalHandler());
    
    writeln("Processing requests through different chains:");
    
    writeln("\nSupport request:");
    writeln(coordinator.processRequest("support", "How do I reset my password?"));
    
    writeln("\nSales request:");
    writeln(coordinator.processRequest("sales", "I want to upgrade my plan"));
    
    writeln("\nTechnical request:");
    writeln(coordinator.processRequest("technical", "API returning error 500"));
    
    writeln();
}

/// Example 8: Complex Escalation with Conditions
void example8_ComplexEscalation() {
    writeln("--- Example 8: Complex Escalation System ---");
    
    class PriorityFilter : ConditionalHandler {
        override bool shouldHandle(string request) {
            return request.indexOf("priority:high") >= 0;
        }
        
        protected override string doHandle(string request) {
            return "HIGH PRIORITY - Escalated immediately to management";
        }
    }
    
    class BusinessHoursFilter : ConditionalHandler {
        override bool shouldHandle(string request) {
            return request.indexOf("hours:business") >= 0;
        }
        
        protected override string doHandle(string request) {
            return "Business hours - Assigned to available agent";
        }
    }
    
    class AfterHoursHandler : BaseHandler {
        override string handle(string request) {
            return "After hours - Added to queue for next business day";
        }
    }
    
    auto priority = new PriorityFilter();
    auto businessHours = new BusinessHoursFilter();
    auto afterHours = new AfterHoursHandler();
    
    priority.setNext(businessHours).setNext(afterHours);
    
    string[] requests = [
        "priority:high Issue with payment processing",
        "hours:business Customer needs assistance",
        "General inquiry from customer"
    ];
    
    foreach (request; requests) {
        writeln("\nRequest: ", request);
        auto result = priority.handle(request);
        writeln("Routing: ", result);
    }
    
    writeln();
}
