# UIM Events Library

A comprehensive, type-safe event management system for D language applications, providing powerful event dispatching, listener management, and declarative event handling through User Defined Attributes (UDAs).

## Overview

The UIM Events library offers a robust event-driven architecture that enables loose coupling between components in your application. Built on top of `uim-core` and `uim-oop`, it provides both imperative and declarative approaches to event handling with strong compile-time type checking.

## Key Features

### Core Capabilities
- **Event Objects**: Strongly-typed event objects with metadata and timestamp tracking
- **Event Dispatcher**: Centralized event dispatching system with efficient listener management
- **Event Listeners**: Flexible listener registration with callback support
- **Event Subscribers**: Group multiple event listeners into reusable subscriber classes
- **Priority System**: Fine-grained control over listener execution order
- **Event Propagation Control**: Stop event propagation to prevent downstream listeners from executing
- **One-Time Listeners**: Automatically unregister after first execution
- **Type Safety**: Full compile-time type checking for events and handlers

### Advanced Features
- **UDA Support**: Declarative event handling using `@EventListener` and `@EventListenerOnce` attributes
- **Annotated Handlers**: Automatic listener registration from class methods via reflection
- **Event Interface**: `IEvent` interface for maximum flexibility and testability
- **Metadata Storage**: Attach arbitrary JSON data to events for rich context passing
- **Event Subscribers**: Organize related listeners into subscriber classes

## Installation

Add the dependency to your `dub.sdl` or `dub.json`:

**dub.sdl:**
```d
dependency "uim-events" version="~>1.0.0"
```

**dub.json:**
```json
{
    "dependencies": {
        "uim-events": "~>1.0.0"
    }
}
```

## Quick Start

### Basic Event Dispatching

The simplest way to use events:

```d
import uim.events;

// Create a dispatcher
auto dispatcher = EventDispatcher();

// Register a listener
dispatcher.on("user.login", (IEvent event) {
    writeln("User logged in!");
});

// Dispatch an event
dispatcher.dispatch(Event("user.login"));
```

### Custom Events with Data

Create custom event classes to carry domain-specific data:

```d
// Define a custom event
class UserRegisteredEvent : DEvent {
    string username;
    string email;
    
    this(string username, string email) {
        super("user.registered");
        this.username = username;
        this.email = email;
    }
}

// Register listener and dispatch
auto dispatcher = EventDispatcher();

dispatcher.on("user.registered", (IEvent event) {
    auto userEvent = cast(UserRegisteredEvent)event;
    writeln("Welcome ", userEvent.username, "! Email: ", userEvent.email);
});

dispatcher.dispatch(new UserRegisteredEvent("john_doe", "john@example.com"));
```

## Core Concepts

### Event Dispatcher

The `DEventDispatcher` is the central hub for managing and dispatching events:

```d
auto dispatcher = EventDispatcher();

// Add listener with callback
dispatcher.on("event.name", (IEvent event) {
    // Handle event
});

// Add one-time listener
dispatcher.once("app.start", (IEvent event) {
    writeln("Runs only once");
});

// Dispatch an event
dispatcher.dispatch(Event("event.name"));

// Check if event has listeners
if (dispatcher.hasListeners("event.name")) {
    // ...
}

// Get all listeners for an event
auto listeners = dispatcher.getListeners("event.name");

// Remove specific listener
dispatcher.removeListener("event.name", listener);

// Remove all listeners for an event
dispatcher.removeListeners("event.name");
```

### Event Priority System

Control the execution order of listeners using priorities (higher values execute first):

```d
// High priority - executes first
dispatcher.on("order.placed", (IEvent event) {
    writeln("1. Validate order");
}, 10);

// Medium priority - executes second
dispatcher.on("order.placed", (IEvent event) {
    writeln("2. Process payment");
}, 5);

// Default priority (0) - executes last
dispatcher.on("order.placed", (IEvent event) {
    writeln("3. Send confirmation");
}, 0);
```

### Event Propagation Control

Stop event propagation to prevent subsequent listeners from executing:

```d
dispatcher.on("validation.check", (IEvent event) {
    if (/* validation fails */) {
        event.stopPropagation();
        writeln("Validation failed - stopping");
    }
}, 10);

dispatcher.on("validation.check", (IEvent event) {
    // This won't execute if propagation was stopped
    writeln("Processing validated data");
}, 0);
```

### Event Metadata

Attach arbitrary data to events using JSON:

```d
auto event = Event("data.processed");
event.setData("records", Json(100));
event.setData("duration", Json("2.5s"));
event.setData("status", Json("success"));

dispatcher.on("data.processed", (IEvent event) {
    auto records = event.getData("records");
    auto duration = event.getData("duration");
    writeln("Processed ", records.get!int, " records in ", duration.get!string);
});

dispatcher.dispatch(event);
```

### Event Subscribers

Group related event listeners into reusable subscriber classes:

```d
class UserEventSubscriber : DEventSubscriber {
    override void subscribe(DEventDispatcher dispatcher) {
        dispatcher.on("user.login", (IEvent event) {
            // Handle login
        });
        
        dispatcher.on("user.logout", (IEvent event) {
            // Handle logout
        });
        
        dispatcher.on("user.registered", (IEvent event) {
            // Handle registration
        }, 10);
    }
}

// Register all listeners from subscriber
auto subscriber = new UserEventSubscriber();
subscriber.subscribe(dispatcher);
```

## Declarative Event Handling with UDAs

UDAs provide a clean, declarative way to define event handlers without explicit registration code.

### Basic UDA Usage

```d
import uim.events;

class UserEventHandler : DAnnotatedEventHandler {
    // Basic event listener
    @EventListener("user.login")
    void onUserLogin(IEvent event) {
        writeln("User logged in");
    }
    
    // Listener with custom priority
    @EventListener("user.registered", 10)
    void sendWelcomeEmail(IEvent event) {
        auto userEvent = cast(UserRegisteredEvent)event;
        writeln("Sending email to: ", userEvent.email);
    }
    
    // One-time listener
    @EventListenerOnce("app.initialized")
    void onAppStart(IEvent event) {
        writeln("App started - runs only once");
    }
}

// Register handler with dispatcher
auto dispatcher = EventDispatcher();
auto handler = new UserEventHandler();
handler.registerWith(dispatcher);

// Dispatch events - handlers are called automatically
dispatcher.dispatch(Event("user.login"));
dispatcher.dispatch(new UserRegisteredEvent("john", "john@example.com"));
```

### Marking Event Classes

```d
@UseEvent("user.registered")
class UserRegisteredEvent : DEvent {
    string username;
    string email;
    
    this(string username, string email) {
        super("user.registered");
        this.username = username;
        this.email = email;
    }
}
```

### Multiple Handlers for Same Event

You can define multiple handlers for the same event, and they'll execute in priority order:

```d
class OrderEventHandler : DAnnotatedEventHandler {
    @EventListener("order.placed", 10)
    void validateOrder(IEvent event) {
        writeln("1. Validating order...");
    }
    
    @EventListener("order.placed", 5)
    void processPayment(IEvent event) {
        writeln("2. Processing payment...");
    }
    
    @EventListener("order.placed", 0)
    void sendConfirmation(IEvent event) {
        writeln("3. Sending confirmation...");
    }
}
```

## API Reference

### Available UDAs

- **`@EventListener("event.name", priority)`** - Mark a method as an event listener
  - `priority` is optional, defaults to 0
  - Higher priority values execute first
  
- **`@EventListenerOnce("event.name", priority)`** - Mark a method as a one-time event listener
  - Automatically unregisters after first execution
  - `priority` is optional, defaults to 0

- **`@UseEvent("event.name")`** - Mark an event class (documentation/metadata)

### Core Classes

#### DEvent
Base class for all events:
```d
class DEvent : UIMObject, IEvent {
    this(string eventName);
    
    // Properties
    string name();
    SysTime timestamp();
    bool stopped();
    Json[string] data();
    
    // Methods
    void stopPropagation();
    bool isPropagationStopped();
    IEvent setData(string key, Json value);
    Json getData(string key, Json defaultValue = Json(null));
    bool hasKey(string key);
}
```

#### DEventDispatcher
Central event dispatcher:
```d
class DEventDispatcher : UIMObject {
    // Add listeners
    DEventDispatcher addListener(string eventName, DEventListener listener);
    DEventDispatcher on(string eventName, EventCallback callback, int priority = 0);
    DEventDispatcher once(string eventName, EventCallback callback, int priority = 0);
    
    // Remove listeners
    DEventDispatcher removeListener(string eventName, DEventListener listener);
    DEventDispatcher removeListeners(string eventName);
    
    // Query listeners
    DEventListener[] getListeners(string eventName);
    bool hasListeners(string eventName);
    
    // Dispatch events
    IEvent dispatch(IEvent event);
}
```

#### DAnnotatedEventHandler
Base class for handlers using UDAs:
```d
class DAnnotatedEventHandler : UIMObject {
    void registerWith(DEventDispatcher dispatcher);
}
```

#### DEventSubscriber
Base class for event subscribers:
```d
abstract class DEventSubscriber : UIMObject, IEventSubscriber {
    abstract void subscribe(DEventDispatcher dispatcher);
}
```

## Usage Examples

### Example 1: User Authentication System

```d
import uim.events;

// Define events
class UserLoginEvent : DEvent {
    string username;
    string ipAddress;
    
    this(string username, string ipAddress) {
        super("user.login");
        this.username = username;
        this.ipAddress = ipAddress;
    }
}

class UserLogoutEvent : DEvent {
    string username;
    
    this(string username) {
        super("user.logout");
        this.username = username;
    }
}

// Create handler
class AuthEventHandler : DAnnotatedEventHandler {
    @EventListener("user.login", 10)
    void logLogin(IEvent event) {
        auto loginEvent = cast(UserLoginEvent)event;
        writeln("Login: ", loginEvent.username, " from ", loginEvent.ipAddress);
    }
    
    @EventListener("user.login", 5)
    void updateLastSeen(IEvent event) {
        auto loginEvent = cast(UserLoginEvent)event;
        // Update database...
    }
    
    @EventListener("user.logout")
    void logLogout(IEvent event) {
        auto logoutEvent = cast(UserLogoutEvent)event;
        writeln("Logout: ", logoutEvent.username);
    }
}

// Usage
auto dispatcher = EventDispatcher();
auto authHandler = new AuthEventHandler();
authHandler.registerWith(dispatcher);

dispatcher.dispatch(new UserLoginEvent("alice", "192.168.1.1"));
dispatcher.dispatch(new UserLogoutEvent("alice"));
```

### Example 2: E-commerce Order Processing

```d
class OrderPlacedEvent : DEvent {
    int orderId;
    decimal total;
    
    this(int orderId, decimal total) {
        super("order.placed");
        this.orderId = orderId;
        this.total = total;
    }
}

class OrderEventHandler : DAnnotatedEventHandler {
    @EventListener("order.placed", 10)
    void validateInventory(IEvent event) {
        auto order = cast(OrderPlacedEvent)event;
        if (/* insufficient inventory */) {
            event.stopPropagation();  // Stop processing
            return;
        }
    }
    
    @EventListener("order.placed", 5)
    void processPayment(IEvent event) {
        auto order = cast(OrderPlacedEvent)event;
        // Process payment for order.total
    }
    
    @EventListener("order.placed", 0)
    void sendConfirmation(IEvent event) {
        auto order = cast(OrderPlacedEvent)event;
        // Send order confirmation email
    }
}
```

### Example 3: Application Lifecycle Events

```d
class AppEventSubscriber : DEventSubscriber {
    override void subscribe(DEventDispatcher dispatcher) {
        // Application startup
        dispatcher.once("app.startup", (IEvent event) {
            writeln("Initializing application...");
            // Load configuration, connect to database, etc.
        });
        
        // Health check events
        dispatcher.on("app.healthcheck", (IEvent event) {
            // Perform health checks
            event.setData("status", Json("healthy"));
            event.setData("uptime", Json(getUptime()));
        });
        
        // Application shutdown
        dispatcher.once("app.shutdown", (IEvent event) {
            writeln("Shutting down gracefully...");
            // Close connections, save state, etc.
        });
    }
}
```

## Best Practices

1. **Use Descriptive Event Names**: Use dot-notation for namespacing (e.g., `user.login`, `order.placed`, `payment.processed`)

2. **Create Custom Event Classes**: For events with data, create dedicated event classes rather than using metadata

3. **Set Appropriate Priorities**: Use priorities to control execution order:
   - Validation: 10+
   - Business logic: 5-10
   - Side effects (logging, notifications): 0-5

4. **Use Stop Propagation Wisely**: Only stop propagation when absolutely necessary (e.g., validation failures)

5. **Prefer UDAs for Static Handlers**: Use `@EventListener` for handlers that don't change at runtime

6. **Use Subscribers for Grouping**: Group related event handlers into subscriber classes for better organization

7. **Type Safety**: Always cast events to their specific type to access custom properties safely

8. **One-Time Listeners**: Use `once()` or `@EventListenerOnce` for initialization or setup events

## Testing

The library includes comprehensive unit tests. Run them with:

```bash
dub test
```

## Dependencies

- `uim-core` - Core UIM functionality
- `uim-oop` - Object-oriented programming utilities

## Examples

Complete working examples can be found in the `examples/` directory:
- `example.d` - Basic usage examples
- `example_uda.d` - UDA-based event handling examples

Run examples:
```bash
cd examples
dub run
```

## Contributing

Contributions are welcome! Please ensure:
- All tests pass
- New features include tests
- Code follows the existing style
- Documentation is updated

## License

Apache 2.0 License - See [LICENSE.txt](LICENSE.txt)

## Authors

© 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)

## See Also

- [UIM Framework Documentation](https://github.com/UIMSolutions/uim-framework)
- [D Language](https://dlang.org/)
- [DUB Package Manager](https://code.dlang.org/)
