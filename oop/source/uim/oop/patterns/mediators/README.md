# Mediator Pattern

## Overview

The Mediator pattern is a behavioral design pattern that defines an object that encapsulates how a set of objects interact. It promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.

The pattern restricts direct communications between objects and forces them to collaborate only via a mediator object.

## Purpose

- **Reduce coupling** between components that communicate with each other
- **Centralize control** of complex communication and coordination logic
- **Simplify object protocols** by replacing many-to-many relationships with one-to-many relationships
- **Make component interactions** more flexible and reusable

## UML Structure

```
┌─────────────┐
│  IMediator  │
└─────────────┘
       △
       │
       │
┌──────┴────────┐
│ConcreteMediator│
│ ┌───────────┐ │
│ │  notify   │ │
│ └───────────┘ │
└───────────────┘
       ▲
       │ knows
       │
┌──────┴──────┐
│ IColleague  │
└─────────────┘
       △
       │
┌──────┴────────┐
│BaseColleague  │
│  - mediator   │
└───────────────┘
```

## Components

### Core Interfaces

1. **IMediator**: Defines the interface for communication with colleague objects
   - `notify(sender, event, data)`: Notifies the mediator about an event from a colleague

2. **IColleague**: Interface for components that communicate through the mediator
   - `mediator` property: Reference to the mediator
   - `mediator(value)` setter: Sets the mediator reference

3. **IGenericMediator<TMessage>**: Type-safe mediator for specific message types
   - `register(id, handler)`: Registers a handler for a specific ID
   - `unregister(id)`: Removes a handler
   - `send(sender, message)`: Sends a typed message to all registered handlers

4. **IEventMediator**: Pub/sub style mediator for event-based communication
   - `subscribe(eventName, handler)`: Subscribes to an event
   - `publish(eventName, data)`: Publishes an event to all subscribers

5. **IRequestResponseMediator**: Request-response style mediator
   - `registerHandler(requestType, handler)`: Registers a request handler
   - `request(requestType, data)`: Makes a request and receives a response

6. **IComponent**: Generic component interface for mediator pattern
   - `notify(sender, event)`: Notifies the mediator about an event

### Concrete Implementations

1. **BaseColleague**: Abstract base class for colleagues
   - Stores mediator reference
   - Provides protected access to mediator

2. **ConcreteMediator**: Basic mediator implementation
   - Manages a collection of colleagues
   - Routes notifications between colleagues

3. **GenericMediator<TMessage>**: Type-safe message routing
   - Maintains handlers with unique IDs
   - Broadcasts messages to all registered handlers

4. **EventMediator**: Event-based pub/sub system
   - Manages event subscriptions
   - Publishes events to subscribers

5. **RequestResponseMediator**: Request-response handler
   - Maps request types to handler functions
   - Returns responses from handlers

## Real-World Examples

### 1. Chat Room

A chat room mediates communication between users:

```d
auto chatRoom = new ChatRoom();
auto alice = new User("Alice");
auto bob = new User("Bob");

chatRoom.registerUser(alice);
chatRoom.registerUser(bob);

alice.sendMessage("all", "Hello everyone!");  // Broadcast
alice.sendMessage("Bob", "Private message");  // Private
```

**Benefits:**
- Users don't need references to each other
- Easy to add logging, moderation, filtering
- Can change routing logic without affecting users

### 2. Air Traffic Control

ATC coordinates aircraft without them communicating directly:

```d
auto atc = new AirTrafficControl();
auto flight1 = new Aircraft("UA123");
auto flight2 = new Aircraft("DL456");

atc.registerAircraft(flight1);
atc.registerAircraft(flight2);

flight1.requestLanding();  // Coordinated through ATC
flight2.requestTakeoff();  // Coordinated through ATC
```

**Benefits:**
- Centralized coordination and conflict resolution
- Safety checks and validation in one place
- Complete communication log

### 3. UI Dialog Coordinator

Dialog mediator manages form field interactions:

```d
auto mediator = new DialogMediator();
auto submitBtn = new Button("submit");
auto nameInput = new TextBox("name");
auto agreeBox = new CheckBox("agree");

mediator.setSubmitButton(submitBtn);
mediator.setNameInput(nameInput);
mediator.setAgreeCheckbox(agreeBox);

// Mediator automatically enables/disables submit button
// based on name input and checkbox state
```

**Benefits:**
- Form validation logic in one place
- UI components remain simple and reusable
- Easy to change validation rules

## When to Use

Use the Mediator pattern when:

1. **Complex Communication**: A set of objects communicate in well-defined but complex ways
2. **Tight Coupling**: Objects are tightly coupled and hard to reuse independently
3. **Distributed Behavior**: Behavior is distributed among several classes and you want to customize it
4. **Central Control**: You need a single place to manage object interactions

## When Not to Use

Avoid the Mediator pattern when:

1. **Simple Interactions**: Object interactions are straightforward
2. **Performance Critical**: The mediator becomes a performance bottleneck
3. **Unnecessary Layer**: Direct communication is clearer and more efficient
4. **God Object Risk**: The mediator becomes too complex and does too much

## Benefits

✅ **Loose Coupling**: Components don't reference each other directly  
✅ **Single Responsibility**: Interaction logic is in the mediator  
✅ **Open/Closed**: Easy to add new components without changing existing ones  
✅ **Reusability**: Components can be reused with different mediators  
✅ **Centralized Control**: All coordination logic in one place  

## Drawbacks

❌ **Mediator Complexity**: Can become a "god object" with too many responsibilities  
❌ **Single Point of Failure**: All interactions depend on the mediator  
❌ **Reduced Performance**: Extra indirection can slow down communication  
❌ **Testing Challenges**: Need to test mediator and component interactions  

## Implementation Variants

### 1. Basic Mediator
Simple notification-based mediator for general use.

### 2. Generic Typed Mediator
Type-safe message passing with compile-time checks.

### 3. Event-Based Mediator
Pub/sub pattern for loosely coupled event handling.

### 4. Request-Response Mediator
Request-response pattern for synchronous communication.

## Best Practices

1. **Keep It Focused**: Don't let the mediator become a god object
2. **Define Clear Protocols**: Document how components should interact
3. **Use Interfaces**: Program to interfaces, not implementations
4. **Consider Variants**: Choose the right mediator type for your use case
5. **Centralize Logic**: Put coordination logic in the mediator, not components
6. **Monitor Complexity**: Refactor if the mediator gets too complex
7. **Test Interactions**: Write tests for all component interactions
8. **Document Communication**: Clearly document the communication protocol

## Related Patterns

- **Observer**: Mediator uses observer pattern for notifications
- **Facade**: Facade simplifies interface; mediator coordinates interaction
- **Command**: Commands can be sent through a mediator
- **Chain of Responsibility**: Alternative way to distribute requests

## Example Scenarios

### Without Mediator (Tightly Coupled)
```d
class Component1 {
    Component2 comp2;
    Component3 comp3;
    Component4 comp4;
    // Needs to know about all other components
}

// N components = N*(N-1) connections
```

### With Mediator (Loosely Coupled)
```d
class Component1 {
    IMediator mediator;
    // Only knows about the mediator
}

// N components = N connections to mediator
```

## Testing

The implementation includes comprehensive unit tests covering:

- Mediator creation and setup
- Message routing and broadcasting
- Event subscription and publishing
- Request-response handling
- Chat room functionality
- Air traffic control coordination
- UI dialog validation
- Multiple handler scenarios
- Edge cases and error handling

Run tests with:
```bash
dub test
```

## References

- **Design Patterns**: Elements of Reusable Object-Oriented Software (Gang of Four)
- **Head First Design Patterns**
- **Refactoring Guru**: https://refactoring.guru/design-patterns/mediator

## License

This implementation is part of the UIM (Universal Interface Manager) framework.
