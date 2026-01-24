/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

# UIM-Events UML Description

## Overview
The UIM-Events framework provides a robust event-driven architecture implementing the Observer pattern. It enables decoupled communication between components through an event dispatcher system with support for synchronous/asynchronous dispatching, priority-based listener execution, one-time listeners, and annotation-based event handling.

## Architecture Layers

### 1. Core Interfaces (uim.events.interfaces)

```plantuml
@startuml Events_Interfaces

interface IEvent {
  + name(): string
  + name(value: string): IEvent
  + timestamp(): SysTime
  + timestamp(value: SysTime): IEvent
  + stopped(): bool
  + stopped(value: bool): IEvent
  + data(): Json[string]
  + data(value: Json[string]): IEvent
  + stopPropagation(): void
  + isPropagationStopped(): bool
  + setData(key: string, value: Json): IEvent
  + getData(key: string, defaultValue: Json): Json
  + hasKey(key: string): bool
}

interface IEventSubscriber {
  + subscribe(dispatcher: UIMEventDispatcher): void
}

@enduml
```

### 2. Core Classes

```plantuml
@startuml Events_Core_Classes

class UIMEvent {
  - _name: string
  - _timestamp: SysTime
  - _stopped: bool
  - _data: Json[string]
  - _propagationStopped: bool
  
  + this()
  + this(eventName: string)
  + name(): string
  + name(value: string): IEvent
  + timestamp(): SysTime
  + timestamp(value: SysTime): IEvent
  + stopped(): bool
  + stopped(value: bool): IEvent
  + data(): Json[string]
  + data(value: Json[string]): IEvent
  + stopPropagation(): void
  + isPropagationStopped(): bool
  + setData(key: string, value: Json): IEvent
  + getData(key: string, defaultValue: Json): Json
  + hasKey(key: string): bool
}

class UIMEventListener {
  - _callback: EventCallback
  - _priority: int
  - _once: bool
  - _executed: bool
  
  + this()
  + this(callback: EventCallback, priority: int)
  + callback(): EventCallback
  + callback(value: EventCallback): UIMEventListener
  + priority(): int
  + priority(value: int): UIMEventListener
  + once(): bool
  + once(value: bool): UIMEventListener
  + execute(event: IEvent): void
  + hasExecuted(): bool
}

class UIMEventDispatcher {
  - _listeners: UIMEventListener[][string]
  
  + this()
  + addListener(eventName: string, listener: UIMEventListener): UIMEventDispatcher
  + removeListener(eventName: string, listener: UIMEventListener): UIMEventDispatcher
  + removeListeners(eventName: string): UIMEventDispatcher
  + on(eventName: string, callback: EventCallback, priority: int): UIMEventDispatcher
  + once(eventName: string, callback: EventCallback, priority: int): UIMEventDispatcher
  + getListeners(eventName: string): UIMEventListener[]
  + hasListeners(eventName: string): bool
  + dispatch(event: IEvent): IEvent
  + dispatchAsync(event: IEvent): void
  + clearListeners(): void
}

abstract class UIMEventSubscriber {
  + this()
  + {abstract} subscribe(dispatcher: UIMEventDispatcher): void
}

UIMEvent ..|> IEvent
UIMEventSubscriber ..|> IEventSubscriber

UIMEventDispatcher o-- UIMEventListener : manages
UIMEventListener --> IEvent : handles

@enduml
```

### 3. Annotation-Based Event Handling

```plantuml
@startuml Events_Annotations

struct EventListener {
  + eventName: string
  + priority: int
  
  + this(name: string, prio: int)
}

struct EventListenerOnce {
  + eventName: string
  + priority: int
  
  + this(name: string, prio: int)
}

struct Priority {
  + value: int
  
  + this(val: int)
}

abstract class DAnnotateUIMEventHandler {
  + this()
  + {abstract} registerWith(dispatcher: UIMEventDispatcher): void
}

class "<<mixin>> RegisterAnnotated" as RegisterAnnotated {
  + registerWith(dispatcher: UIMEventDispatcher): void
}

note right of RegisterAnnotated
  Mixin template that implements
  registerWith by scanning UDAs
end note

note left of EventListener
  UDA: @EventListener("event.name", priority)
  Marks a method as an event listener
end note

note left of EventListenerOnce
  UDA: @EventListenerOnce("event.name", priority)
  Marks a method as a one-time listener
end note

DAnnotateUIMEventHandler <.. RegisterAnnotated : uses

@enduml
```

### 4. Event Lifecycle and Flow

```plantuml
@startuml Events_Lifecycle_Sequence

actor Client
participant Dispatcher as "UIMEventDispatcher"
participant Event as "IEvent"
participant "Listener 1\n(Priority 10)" as L1
participant "Listener 2\n(Priority 5)" as L2
participant "Listener 3\n(Priority 0)" as L3

Client -> Dispatcher: on("user.login", callback, priority)
activate Dispatcher
Dispatcher -> Dispatcher: Sort listeners by priority
deactivate Dispatcher

Client -> Event: new UIMEvent("user.login")
activate Event
Event -> Event: timestamp = now()
deactivate Event

Client -> Dispatcher: dispatch(event)
activate Dispatcher

Dispatcher -> Dispatcher: getListeners("user.login")
Dispatcher -> Dispatcher: Clean up one-time listeners

Dispatcher -> L1: execute(event)
activate L1
L1 -> Event: callback(event)
L1 -> Event: isPropagationStopped()
Event --> L1: false
deactivate L1

Dispatcher -> L2: execute(event)
activate L2
L2 -> Event: callback(event)
L2 -> Event: isPropagationStopped()
Event --> L2: false
deactivate L2

Dispatcher -> L3: execute(event)
activate L3
L3 -> Event: callback(event)
L3 -> Event: isPropagationStopped()
Event --> L3: false
deactivate L3

Dispatcher --> Client: event (modified)
deactivate Dispatcher

@enduml
```

### 5. Priority-Based Execution

```plantuml
@startuml Events_Priority_System

class UIMEventDispatcher {
  - _listeners: UIMEventListener[][string]
}

class UIMEventListener {
  - _priority: int
  - _callback: EventCallback
}

note right of UIMEventDispatcher
  Listeners are stored sorted by priority:
  Higher priority (10) → Lower priority (0)
  
  When a listener is added:
  1. Add to array
  2. Sort by priority (descending)
  3. Execute in order during dispatch
end note

UIMEventDispatcher --> UIMEventListener : "maintains sorted list"

@enduml
```

### 6. Propagation Control

```plantuml
@startuml Events_Propagation

participant Client
participant Event as "IEvent"
participant Dispatcher as "UIMEventDispatcher"
participant L1 as "Listener 1"
participant L2 as "Listener 2"
participant L3 as "Listener 3"

Client -> Dispatcher: dispatch(event)
activate Dispatcher

Dispatcher -> L1: execute(event)
activate L1
L1 -> Event: callback()
L1 -> Event: isPropagationStopped()
Event --> L1: false
deactivate L1

Dispatcher -> L2: execute(event)
activate L2
L2 -> Event: callback()
L2 -> Event: stopPropagation()
Event -> Event: _propagationStopped = true
L2 -> Event: isPropagationStopped()
Event --> L2: true
deactivate L2

note right of L3
  L3 is never executed because
  propagation was stopped by L2
end note

Dispatcher --> Client: event (stopped)
deactivate Dispatcher

@enduml
```

### 7. One-Time Listeners

```plantuml
@startuml Events_OneTime_Listeners

class UIMEventListener {
  - _once: bool
  - _executed: bool
  
  + execute(event: IEvent): void
  + hasExecuted(): bool
}

note right of UIMEventListener
  One-time listener behavior:
  
  1. First execution:
     - _executed = false
     - Execute callback
     - Set _executed = true
  
  2. Subsequent calls:
     - _executed = true
     - Skip callback execution
  
  3. Cleanup:
     - Dispatcher removes executed
       one-time listeners during dispatch
end note

@enduml
```

### 8. Synchronous vs Asynchronous Dispatch

```plantuml
@startuml Events_Sync_Async

participant Client
participant Dispatcher as "UIMEventDispatcher"
participant Event as "IEvent"
participant Listener

== Synchronous Dispatch ==
Client -> Dispatcher: dispatch(event)
activate Dispatcher
Dispatcher -> Listener: execute(event)
activate Listener
Listener --> Dispatcher: (blocks)
deactivate Listener
Dispatcher --> Client: event (completed)
deactivate Dispatcher

== Asynchronous Dispatch ==
Client -> Dispatcher: dispatchAsync(event)
activate Dispatcher
Dispatcher -> Dispatcher: runTask()
Dispatcher --> Client: (returns immediately)
deactivate Dispatcher

activate Listener
note right of Listener
  Listeners execute in
  separate vibe.d tasks
end note
deactivate Listener

@enduml
```

### 9. Annotated Event Handler Registration

```plantuml
@startuml Events_Annotated_Registration

actor Developer
participant Handler as "UserEventHandler\n:DAnnotateUIMEventHandler"
participant Mixin as "RegisterAnnotated"
participant Scanner as "registerAnnotatedListeners"
participant Dispatcher as "UIMEventDispatcher"

Developer -> Handler: Create class with @EventListener methods
Developer -> Handler: mixin RegisterAnnotated

Developer -> Dispatcher: Create dispatcher
Developer -> Handler: new UserEventHandler()

Developer -> Handler: registerWith(dispatcher)
activate Handler
Handler -> Mixin: registerWith(dispatcher)
activate Mixin

Mixin -> Scanner: registerAnnotatedListeners(this, dispatcher)
activate Scanner

Scanner -> Scanner: Scan __traits(allMembers)
Scanner -> Scanner: Find @EventListener UDAs
Scanner -> Scanner: Find @EventListenerOnce UDAs

loop For each annotated method
  Scanner -> Dispatcher: on(eventName, method, priority)
end

Scanner --> Mixin: done
deactivate Scanner
Mixin --> Handler: done
deactivate Mixin
Handler --> Developer: registered
deactivate Handler

@enduml
```

### 10. Complete System Architecture

```plantuml
@startuml Events_Complete_Architecture

package "uim.events.interfaces" {
  interface IEvent
  interface IEventSubscriber
}

package "uim.events" {
  class UIMEvent
  class UIMEventListener
  class UIMEventDispatcher
  class UIMEventSubscriber
}

package "uim.events.attributes" {
  struct EventListener
  struct EventListenerOnce
  struct Priority
}

package "uim.events.annotated" {
  abstract class DAnnotateUIMEventHandler
  class "<<mixin>> RegisterAnnotated" as RegisterAnnotated
  class "<<function>> registerAnnotatedListeners" as RegFunc
}

' Implementations
UIMEvent ..|> IEvent
UIMEventSubscriber ..|> IEventSubscriber

' Relationships
UIMEventDispatcher o-- "0..*" UIMEventListener : manages
UIMEventListener --> IEvent : executes on
UIMEventSubscriber --> UIMEventDispatcher : subscribes to

' Annotations
DAnnotateUIMEventHandler --> UIMEventDispatcher : registers with
RegisterAnnotated ..> RegFunc : uses
RegFunc ..> EventListener : scans for
RegFunc ..> EventListenerOnce : scans for
RegFunc --> UIMEventDispatcher : registers listeners

' Factory functions
class EventFactory <<utility>> {
  + {static} Event(name: string): UIMEvent
  + {static} createEventListener(callback, priority): UIMEventListener
  + {static} createEventListenerOnce(callback, priority): UIMEventListener
  + {static} EventDispatcher(): UIMEventDispatcher
}

EventFactory ..> UIMEvent : creates
EventFactory ..> UIMEventListener : creates
EventFactory ..> UIMEventDispatcher : creates

@enduml
```

### 11. Event Data Management

```plantuml
@startuml Events_Data_Management

class UIMEvent {
  - _data: Json[string]
  
  + data(): Json[string]
  + data(value: Json[string]): IEvent
  + setData(key: string, value: Json): IEvent
  + getData(key: string, defaultValue: Json): Json
  + hasKey(key: string): bool
}

note right of UIMEvent
  Event data is stored as JSON:
  
  // Set data
  event.setData("userId", Json(123))
  event.setData("action", Json("login"))
  
  // Get data
  auto userId = event.getData("userId")
  auto action = event.getData("action", Json("unknown"))
  
  // Check data
  if (event.hasKey("userId")) { ... }
end note

@enduml
```

### 12. Class Hierarchy

```plantuml
@startuml Events_Class_Hierarchy

class UIMObject <<core>>

interface IEvent
interface IEventSubscriber

class UIMEvent {
  - _name: string
  - _timestamp: SysTime
  - _stopped: bool
  - _data: Json[string]
  - _propagationStopped: bool
}

class UIMEventListener {
  - _callback: EventCallback
  - _priority: int
  - _once: bool
  - _executed: bool
}

class UIMEventDispatcher {
  - _listeners: UIMEventListener[][string]
}

abstract class UIMEventSubscriber {
  + {abstract} subscribe(dispatcher: UIMEventDispatcher)
}

abstract class DAnnotateUIMEventHandler {
  + {abstract} registerWith(dispatcher: UIMEventDispatcher)
}

UIMObject <|-- UIMEvent
UIMObject <|-- UIMEventListener
UIMObject <|-- UIMEventDispatcher
UIMObject <|-- UIMEventSubscriber
UIMObject <|-- DAnnotateUIMEventHandler

IEvent <|.. UIMEvent
IEventSubscriber <|.. UIMEventSubscriber

@enduml
```

## Design Patterns

### 1. Observer Pattern
The core pattern implemented by the framework:
- **Subject**: `UIMEventDispatcher`
- **Observer**: `UIMEventListener`
- **Event**: `UIMEvent`
- Decouples event sources from event handlers

### 2. Strategy Pattern
Different listening strategies:
- Regular listeners (can be called multiple times)
- One-time listeners (execute only once)
- Priority-based execution order

### 3. Decorator Pattern
Event listeners can be wrapped with:
- Priority information
- One-time execution flag
- Async execution wrapper

### 4. Template Method Pattern
`UIMEventSubscriber` and `DAnnotateUIMEventHandler` define the skeleton:
- Base class provides registration mechanism
- Subclasses implement specific event subscriptions

## Key Features

### 1. Priority-Based Execution
Listeners execute in priority order (highest to lowest):
```d
dispatcher.on("event", callback1, priority: 10);  // Executes first
dispatcher.on("event", callback2, priority: 5);   // Executes second
dispatcher.on("event", callback3, priority: 0);   // Executes last
```

### 2. Propagation Control
Events can stop propagation to remaining listeners:
```d
void listener(IEvent event) {
    // Do something
    event.stopPropagation();  // No more listeners will execute
}
```

### 3. One-Time Listeners
Listeners that execute only once then auto-remove:
```d
dispatcher.once("app.init", (event) {
    // Initialization code - runs only once
});
```

### 4. Annotation-Based Registration
Use UDAs to declaratively register event handlers:
```d
class MyHandler : DAnnotateUIMEventHandler {
    mixin RegisterAnnotated;
    
    @EventListener("user.login", 10)
    void onUserLogin(IEvent event) {
        // Handle login
    }
    
    @EventListenerOnce("app.startup")
    void onStartup(IEvent event) {
        // One-time startup logic
    }
}
```

### 5. Asynchronous Dispatching
Non-blocking event dispatch using vibe.d:
```d
dispatcher.dispatchAsync(event);  // Returns immediately
```

### 6. Event Data Management
Events carry arbitrary JSON data:
```d
auto event = Event("user.action");
event.setData("userId", Json(123));
event.setData("action", Json("purchase"));

// In listener
auto userId = event.getData("userId").get!int;
```

## Type Definitions

```d
// Callback type for event listeners
alias EventCallback = void delegate(IEvent event) @safe;
```

## Usage Examples

### Basic Usage
```d
// Create dispatcher
auto dispatcher = EventDispatcher();

// Add listener
dispatcher.on("user.login", (IEvent event) {
    writeln("User logged in!");
});

// Dispatch event
auto event = Event("user.login");
event.setData("userId", Json(42));
dispatcher.dispatch(event);
```

### Priority-Based Listeners
```d
dispatcher.on("order.placed", (event) {
    writeln("Validate order");
}, 10);

dispatcher.on("order.placed", (event) {
    writeln("Process payment");
}, 5);

dispatcher.on("order.placed", (event) {
    writeln("Send confirmation");
}, 0);
```

### Event Subscribers
```d
class OrderEventSubscriber : UIMEventSubscriber {
    override void subscribe(UIMEventDispatcher dispatcher) {
        dispatcher.on("order.created", &onOrderCreated);
        dispatcher.on("order.shipped", &onOrderShipped);
        dispatcher.on("order.delivered", &onOrderDelivered);
    }
    
    void onOrderCreated(IEvent event) { /* ... */ }
    void onOrderShipped(IEvent event) { /* ... */ }
    void onOrderDelivered(IEvent event) { /* ... */ }
}

auto subscriber = new OrderEventSubscriber();
subscriber.subscribe(dispatcher);
```

### Annotated Handlers
```d
class UserEventHandler : DAnnotateUIMEventHandler {
    mixin RegisterAnnotated;
    
    @EventListener("user.registered", 10)
    void sendWelcomeEmail(IEvent event) {
        auto email = event.getData("email").get!string;
        // Send email
    }
    
    @EventListener("user.registered", 5)
    void createProfile(IEvent event) {
        // Create user profile
    }
    
    @EventListenerOnce("app.initialized")
    void onAppInit(IEvent event) {
        // One-time initialization
    }
}

auto handler = new UserEventHandler();
handler.registerWith(dispatcher);
```

### Propagation Control
```d
dispatcher.on("validation", (event) {
    if (!isValid(event.getData("data"))) {
        event.stopPropagation();  // Stop processing
    }
}, 10);

dispatcher.on("validation", (event) {
    // This won't execute if validation fails
    processData(event.getData("data"));
}, 0);
```

## Benefits

1. **Decoupling**: Components communicate without direct dependencies
2. **Extensibility**: New listeners can be added without modifying existing code
3. **Priority Control**: Fine-grained control over execution order
4. **Flexibility**: Multiple listening strategies (regular, one-time, annotated)
5. **Performance**: Async dispatching for non-blocking operations
6. **Type Safety**: Strong typing with D's type system
7. **Declarative**: UDA-based registration for cleaner code

## Best Practices

1. Use meaningful event names with namespacing: `"module.action"`
2. Set appropriate priorities for listeners that have dependencies
3. Use one-time listeners for initialization tasks
4. Leverage annotations for clean, declarative event handling
5. Include relevant data in events for context
6. Use propagation control for validation scenarios
7. Choose sync vs async dispatch based on requirements
8. Clean up listeners when they're no longer needed

This UML description provides a comprehensive view of the uim-events framework,
showing how components interact to provide a flexible, powerful event system.
