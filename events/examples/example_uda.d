/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module example_uda;

import uim.events;
import std.stdio;

/**
 * Example of a custom event using UDA
 */
@Event("user.registered")
class UserRegisteredEvent : DEvent {
    string username;
    string email;
    
    this(string username, string email) {
        super("user.registered");
        this.username = username;
        this.email = email;
    }
}

/**
 * Example of an event handler using UDAs for method registration
 */
class UserEventHandler : DAnnotatedEventHandler {
    
    // Basic event listener
    @EventListener("user.login")
    void onUserLogin(IEvent event) {
        writeln("✓ User logged in!");
    }
    
    // Listener with priority (higher priority = executes first)
    @EventListener("user.registered", 10)
    void sendWelcomeEmail(IEvent event) {
        auto userEvent = cast(UserRegisteredEvent)event;
        writeln("📧 Sending welcome email to: ", userEvent.email);
    }
    
    // Lower priority - runs after welcome email
    @EventListener("user.registered", 5)
    void createUserProfile(IEvent event) {
        auto userEvent = cast(UserRegisteredEvent)event;
        writeln("👤 Creating profile for: ", userEvent.username);
    }
    
    // Normal priority (0) - runs last
    @EventListener("user.registered", 0)
    void logRegistration(IEvent event) {
        auto userEvent = cast(UserRegisteredEvent)event;
        writeln("📝 Logging registration: ", userEvent.username);
    }
    
    // One-time listener - only executes once
    @EventListenerOnce("app.initialized")
    void onAppInitialized(IEvent event) {
        writeln("🚀 Application initialized (one-time event)");
    }
    
    // Multiple listeners can handle the same event
    @EventListener("user.logout")
    void clearUserSession(IEvent event) {
        writeln("🗑️  Clearing user session");
    }
    
    @EventListener("user.logout")
    void logLogout(IEvent event) {
        writeln("📝 Logging user logout");
    }
}

/**
 * Another handler for order events
 */
class OrderEventHandler : DAnnotatedEventHandler {
    
    @EventListener("order.placed", 10)
    void validateOrder(IEvent event) {
        writeln("✅ Validating order...");
    }
    
    @EventListener("order.placed", 5)
    void processPayment(IEvent event) {
        writeln("💳 Processing payment...");
    }
    
    @EventListener("order.placed", 0)
    void sendConfirmationEmail(IEvent event) {
        writeln("📧 Sending order confirmation email");
    }
    
    @EventListenerOnce("order.first")
    void celebrateFirstOrder(IEvent event) {
        writeln("🎉 First order celebration!");
    }
}

void main() {
    writeln("=== UIM Events Library - UDA Example ===\n");
    
    // Create dispatcher
    auto dispatcher = EventDispatcher();
    
    // Create and register handlers
    auto userHandler = new UserEventHandler();
    auto orderHandler = new OrderEventHandler();
    
    writeln("1. Registering annotated event handlers...");
    userHandler.registerWith(dispatcher);
    orderHandler.registerWith(dispatcher);
    writeln();
    
    // Test user login
    writeln("2. Dispatching user.login event:");
    dispatcher.dispatch(Event("user.login"));
    writeln();
    
    // Test user registration with priority
    writeln("3. Dispatching user.registered event (note priority order):");
    dispatcher.dispatch(new UserRegisteredEvent("john_doe", "john@example.com"));
    writeln();
    
    // Test order placement
    writeln("4. Dispatching order.placed event:");
    dispatcher.dispatch(Event("order.placed"));
    writeln();
    
    // Test one-time events
    writeln("5. Testing one-time listeners:");
    writeln("   First call to app.initialized:");
    dispatcher.dispatch(Event("app.initialized"));
    
    writeln("   Second call to app.initialized (should not execute):");
    dispatcher.dispatch(Event("app.initialized"));
    writeln();
    
    writeln("   First call to order.first:");
    dispatcher.dispatch(Event("order.first"));
    
    writeln("   Second call to order.first (should not execute):");
    dispatcher.dispatch(Event("order.first"));
    writeln();
    
    // Test multiple listeners for same event
    writeln("6. Dispatching user.logout event (multiple listeners):");
    dispatcher.dispatch(Event("user.logout"));
    writeln();
    
    // Mixed approach: UDA + manual registration
    writeln("7. Mixed approach - adding manual listener:");
    dispatcher.on("user.login", (IEvent event) {
        writeln("   👁️  Additional manual listener executed");
    }, 5);
    
    dispatcher.dispatch(Event("user.login"));
    writeln();
    
    writeln("=== UDA Example completed successfully! ===");
}
