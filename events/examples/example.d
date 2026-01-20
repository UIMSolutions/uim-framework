/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module events.examples.example;

import uim.events;
import std.stdio;

void main() {
    writeln("=== UIM Events Library Example ===\n");
    
    // 1. Basic Event Dispatching
    writeln("1. Basic Event Dispatching:");
    auto dispatcher = EventDispatcher();
    
    dispatcher.on("user.login", (IEvent event) {
        writeln("   User logged in!");
    });
    
    auto loginEvent = Event("user.login");
    dispatcher.dispatch(loginEvent);
    
    // 2. Custom Event with Data
    writeln("\n2. Custom Event with Data:");
    class UserRegisteredEvent : DEvent {
        string username;
        string email;
        
        this(string username, string email) {
            super("user.registered");
            this.username = username;
            this.email = email;
        }
    }
    
    dispatcher.on("user.registered", (IEvent event) {
        auto userEvent = cast(UserRegisteredEvent)event;
        writeln("   New user registered:");
        writeln("   - Username: ", userEvent.username);
        writeln("   - Email: ", userEvent.email);
    });
    
    dispatcher.dispatch(new UserRegisteredEvent("john_doe", "john@example.com"));
    
    // 3. Priority-based Listeners
    writeln("\n3. Priority-based Listeners:");
    dispatcher.on("order.placed", (IEvent event) {
        writeln("   [Priority 0] Processing order...");
    }, 0);
    
    dispatcher.on("order.placed", (IEvent event) {
        writeln("   [Priority 10] Validating order first...");
    }, 10);
    
    dispatcher.on("order.placed", (IEvent event) {
        writeln("   [Priority -5] Logging order last...");
    }, -5);
    
    dispatcher.dispatch(Event("order.placed"));
    
    // 4. Stop Propagation
    writeln("\n4. Stop Propagation:");
    dispatcher.on("payment.process", (IEvent event) {
        writeln("   Checking payment method...");
        event.stopPropagation();
        writeln("   Payment failed - stopping propagation");
    }, 10);
    
    dispatcher.on("payment.process", (IEvent event) {
        writeln("   This should not execute!");
    }, 0);
    
    dispatcher.dispatch(Event("payment.process"));
    
    // 5. One-time Listeners
    writeln("\n5. One-time Listeners:");
    dispatcher.once("app.start", (IEvent event) {
        writeln("   Application started (will only show once)");
    });
    
    dispatcher.dispatch(Event("app.start"));
    dispatcher.dispatch(Event("app.start")); // Won't execute
    
    // 6. Event with Metadata
    writeln("\n6. Event with Metadata:");
    auto metadataEvent = Event("data.processed");
    metadataEvent.setData("records", "100");
    metadataEvent.setData("duration", "2.5s");
    
    dispatcher.on("data.processed", (IEvent event) {
        writeln("   Data processing completed:");
        writeln("   - Records: ", event.getData("records"));
        writeln("   - Duration: ", event.getData("duration"));
    });
    
    dispatcher.dispatch(metadataEvent);
    
    // 7. Event Subscriber
    writeln("\n7. Event Subscriber:");
    class EmailNotificationSubscriber : DEventSubscriber {
        override void subscribe(DEventDispatcher dispatcher) {
            dispatcher.on("user.registered", (IEvent event) {
                writeln("   📧 Sending welcome email...");
            });
            
            dispatcher.on("user.login", (IEvent event) {
                writeln("   📧 Sending login notification...");
            });
            
            dispatcher.on("order.placed", (IEvent event) {
                writeln("   📧 Sending order confirmation...");
            });
        }
    }
    
    auto emailSubscriber = new EmailNotificationSubscriber();
    emailSubscriber.subscribe(dispatcher);
    
    writeln("\n   Triggering events with email subscriber:");
    dispatcher.dispatch(new UserRegisteredEvent("jane_doe", "jane@example.com"));
    dispatcher.dispatch(Event("user.login"));
    dispatcher.dispatch(Event("order.placed"));
    
    // 8. Multiple Listeners
    writeln("\n8. Multiple Listeners for Same Event:");
    dispatcher.on("cache.clear", (IEvent event) {
        writeln("   Clearing page cache...");
    });
    
    dispatcher.on("cache.clear", (IEvent event) {
        writeln("   Clearing API cache...");
    });
    
    dispatcher.on("cache.clear", (IEvent event) {
        writeln("   Clearing session cache...");
    });
    
    dispatcher.dispatch(Event("cache.clear"));
    
    writeln("\n=== Example completed successfully! ===");
}
