# UIM Events Library

A comprehensive OOP event management library for D language using vibe.d and uim-oop.

## Features

- **Event Objects**: Strongly-typed event objects with metadata
- **Event Dispatcher**: Central event dispatching system
- **Event Listeners**: Subscribe to and handle events
- **Priority System**: Control event listener execution order
- **Async Support**: Asynchronous event handling with vibe.d
- **Event Propagation**: Control event flow with stop propagation
- **Type Safety**: Compile-time type checking for events
- **UDA Support**: User Defined Attributes for declarative event handling
- **Event Interface**: `IEvent` interface for flexibility

## Usage

### Basic Usage

```d
import uim.events;

// Define a custom event
class UserCreatedEvent : DEvent {
    string username;
    
    this(string username) {
        super("user.created");
        this.username = username;
    }
}

// Create a listener
auto listener = EventListener((IEvent event) {
    auto userEvent = cast(UserCreatedEvent)event;
    writeln("User created: ", userEvent.username);
});

// Dispatch events
auto dispatcher = EventDispatcher();
dispatcher.addListener("user.created", listener);
dispatcher.dispatch(new UserCreatedEvent("john_doe"));
```

### Using UDAs (User Defined Attributes)

UDAs provide a declarative way to define event handlers:

```d
import uim.events;

// Mark event classes with @Event
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

// Use @EventListener to mark handler methods
class UserEventHandler : DAnnotatedEventHandler {
    
    // Basic listener
    @EventListener("user.login")
    void onUserLogin(IEvent event) {
        writeln("User logged in!");
    }
    
    // Listener with priority (higher = executes first)
    @EventListener("user.registered", 10)
    void sendWelcomeEmail(IEvent event) {
        auto userEvent = cast(UserRegisteredEvent)event;
        writeln("Sending welcome email to: ", userEvent.email);
    }
    
    // One-time listener
    @EventListenerOnce("app.initialized")
    void onAppInitialized(IEvent event) {
        writeln("App initialized (runs once)");
    }
}

// Register and use
auto dispatcher = EventDispatcher();
auto handler = new UserEventHandler();
handler.registerWith(dispatcher);

dispatcher.dispatch(new UserRegisteredEvent("john", "john@example.com"));
```

### Available UDAs

- `@EventListener("event.name", priority)` - Mark a method as an event listener
- `@EventListenerOnce("event.name", priority)` - One-time event listener
- `@Event("event.name")` - Mark an event class
- `@Priority(value)` - Specify listener priority
- `@Async` - Mark for asynchronous execution

### Priority System

Higher priority listeners execute first:

```d
@EventListener("order.placed", 10)  // Executes first
void validateOrder(IEvent event) { }

@EventListener("order.placed", 5)   // Executes second
void processPayment(IEvent event) { }

@EventListener("order.placed", 0)   // Executes last
void sendConfirmation(IEvent event) { }
```

## License

Apache 2.0 License - See LICENSE.txt
