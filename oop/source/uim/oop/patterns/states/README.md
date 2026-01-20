# State Pattern

## Overview

The State pattern is a behavioral design pattern that allows an object to alter its behavior when its internal state changes. The object will appear to change its class.

The pattern encapsulates state-specific behavior into separate state classes and delegates behavior to the current state object, eliminating complex conditional logic.

## Purpose

- **Encapsulate state-specific behavior** in separate classes
- **Make state transitions explicit** and manageable
- **Simplify context code** by eliminating large conditional statements
- **Enable easy addition** of new states without modifying existing code
- **Localize state-dependent behavior** in one place

## UML Structure

```
┌─────────────┐
│  IContext   │
│ ┌─────────┐ │
│ │  state  │───────┐
│ └─────────┘ │     │
│  request()  │     │
└─────────────┘     │
                    ▼
              ┌──────────┐
              │  IState  │
              │ ┌──────┐ │
              │ │handle│ │
              │ └──────┘ │
              └──────────┘
                    △
        ┌───────────┼───────────┐
        │           │           │
  ┌─────┴────┐ ┌───┴────┐ ┌───┴────┐
  │StateA    │ │StateB  │ │StateC  │
  │ handle() │ │handle()│ │handle()│
  └──────────┘ └────────┘ └────────┘
```

## Components

### Core Interfaces

1. **IState**: Interface for encapsulating state-specific behavior
   - `handle()`: Performs the state-specific action
   - `name()`: Returns the state identifier

2. **IContext**: Interface for the context that maintains a state
   - `state()` getter: Returns the current state
   - `state(newState)` setter: Changes the state
   - `request()`: Delegates to current state's handle()

3. **IGenericState<TContext>**: Type-safe state interface
   - `handle(context)`: Provides typed access to context

4. **IStateMachine**: High-level state machine interface
   - `currentState()`: Gets current state name
   - `transitionTo(stateName)`: Transitions to a new state
   - `canTransitionTo(stateName)`: Checks if transition is valid
   - `availableStates()`: Lists all registered states

5. **ILifecycleState**: State with enter/exit callbacks
   - `onEnter()`: Called when entering the state
   - `onExit()`: Called when leaving the state

6. **IHierarchicalState**: State that can have substates
   - `parent()`: Gets parent state
   - `substate()`: Gets/sets current substate

### Concrete Implementations

1. **BaseState**: Abstract base class for states
   - Stores state name
   - Provides common functionality

2. **Context**: Basic context implementation
   - Maintains current state
   - Tracks state history
   - Delegates requests to state

3. **StateMachine**: Full-featured state machine
   - Manages state registration
   - Enforces allowed transitions
   - Validates state changes

4. **LifecycleState**: State with lifecycle hooks
   - Enter/exit callback support

5. **LifecycleContext**: Context supporting lifecycle states
   - Automatically calls onEnter/onExit

## Real-World Examples

### 1. Traffic Light

A traffic light cycles through states:

```d
auto light = new TrafficLight();
// Starts in Red state

light.change(); // -> Green
light.change(); // -> Yellow
light.change(); // -> Red (cycle repeats)
```

**States:** Red, Green, Yellow  
**Behavior:** Each state knows the next state  
**Benefit:** No complex conditionals for state transitions

### 2. Document Workflow

A document progresses through workflow states:

```d
auto doc = new Document("Proposal");
// Starts in Draft state

doc.submit(); // -> Review
doc.submit(); // -> Published
doc.submit(); // -> Archived
```

**States:** Draft, Review, Published, Archived  
**Lifecycle:** Enter/exit callbacks for each state  
**Use case:** Content management systems, approval workflows

### 3. TCP Connection

TCP connection state management:

```d
auto conn = new TCPConnection();
// Starts in Closed state

conn.open();        // -> Listen
conn.acknowledge(); // -> Established
conn.close();       // -> Closed
```

**States:** Closed, Listen, Established  
**Protocol:** Follows TCP state machine specification  
**Benefit:** Encapsulates complex protocol logic

## When to Use

Use the State pattern when:

1. **Behavior Changes**: An object's behavior depends on its state
2. **Complex Conditionals**: Large switch/if statements based on state
3. **State-Specific Code**: Different states require different implementations
4. **Runtime Changes**: Object behavior must change at runtime
5. **State Transitions**: State transitions need to be explicit and controlled

## When Not to Use

Avoid the State pattern when:

1. **Simple States**: Only 2-3 simple states with minimal logic
2. **No State Changes**: States don't change at runtime
3. **Overkill**: The added complexity isn't justified
4. **Performance Critical**: Extra indirection is problematic

## Benefits

✅ **Open/Closed Principle**: Add new states without modifying existing code  
✅ **Single Responsibility**: Each state class has one responsibility  
✅ **Eliminates Conditionals**: Replaces switch/if with polymorphism  
✅ **Explicit Transitions**: State changes are clear and traceable  
✅ **Reusable States**: State classes can be reused in different contexts  
✅ **Testable**: Each state can be tested independently  

## Drawbacks

❌ **Class Proliferation**: Many small state classes  
❌ **Increased Complexity**: More classes and indirection  
❌ **Context Coupling**: States may need access to context  
❌ **Transition Management**: Complex transition rules can be hard to manage  

## Implementation Variants

### 1. Basic State Pattern
Simple state delegation with manual state transitions.

### 2. State Machine
Enforces allowed transitions with validation.

### 3. Lifecycle States
Includes enter/exit callbacks for state changes.

### 4. Hierarchical States
Supports nested substates and parent states.

## State vs Strategy Pattern

| Aspect | State | Strategy |
|--------|-------|----------|
| **Purpose** | Change behavior based on internal state | Change algorithm based on client choice |
| **Who decides** | Object decides state changes | Client decides strategy |
| **Awareness** | States may know about each other | Strategies are independent |
| **Transitions** | State can trigger transitions | No automatic transitions |
| **Intent** | Model object lifecycle | Provide algorithm alternatives |

## Best Practices

1. **Keep States Focused**: Each state should have one clear responsibility
2. **Use Lifecycle Hooks**: Implement onEnter/onExit for initialization/cleanup
3. **Validate Transitions**: Use state machine to enforce valid transitions
4. **Document State Diagram**: Create a visual state diagram
5. **Test Each State**: Write unit tests for each state's behavior
6. **Consider Context Access**: Decide how states access context data
7. **Handle Invalid Transitions**: Gracefully handle invalid state changes
8. **Log State Changes**: Track state history for debugging

## Transition Rules

### Free Transitions
Any state can transition to any other state (basic Context).

### Controlled Transitions
State machine enforces specific allowed transitions:

```d
machine.allowTransition("Draft", "Review");
machine.allowTransition("Review", "Published");
// Draft cannot directly go to Published
```

### Self-Managed Transitions
States manage their own transitions:

```d
class RedLight : BaseState {
    override void handle() {
        context.setState(new GreenLight());
    }
}
```

## Testing

The implementation includes comprehensive unit tests covering:

- State creation and naming
- Context state changes
- State history tracking
- State machine registration
- Transition validation
- Traffic light cycling
- Document workflow progression
- TCP connection lifecycle
- Lifecycle enter/exit callbacks
- Complex transition scenarios

Run tests with:
```bash
dub test
```

## Example Scenarios

### Vending Machine

**States:** Idle, HasMoney, Dispensing, OutOfStock  
**Transitions:**
- Idle → HasMoney (money inserted)
- HasMoney → Dispensing (product selected)
- Dispensing → Idle (item dispensed)
- Dispensing → OutOfStock (no items left)

### Order Processing

**States:** New, Processing, Shipped, Delivered, Cancelled  
**Transitions:**
- New → Processing or Cancelled
- Processing → Shipped or Cancelled
- Shipped → Delivered

### Game Character

**States:** Standing, Running, Jumping, Crouching  
**Transitions:** Based on player input (WASD, Space, Ctrl)

## Related Patterns

- **Strategy**: Similar structure but different intent
- **Command**: Can be used to trigger state transitions
- **Flyweight**: Share state objects if they have no context-specific data
- **Singleton**: States can be singletons if stateless

## Common Use Cases

1. **UI State Management**: Form validation, wizard steps
2. **Workflow Systems**: Approval processes, document lifecycle
3. **Network Protocols**: TCP, HTTP connection states
4. **Game Development**: Player states, AI behavior, game phases
5. **Order Processing**: E-commerce order fulfillment
6. **Authentication**: Login states (logged out, logging in, authenticated)
7. **Media Players**: Playing, paused, stopped states
8. **Traffic Control**: Traffic lights, railway signals

## Anti-Patterns to Avoid

1. **God State**: State with too much responsibility
2. **Context Overload**: Context knowing too much about states
3. **Missing Validation**: No transition validation
4. **State Duplication**: Duplicating logic across states
5. **Tight Coupling**: States tightly coupled to concrete context

## Performance Considerations

- **State Object Creation**: Consider reusing state objects
- **Transition Overhead**: Minimal if states are stateless
- **History Tracking**: Can consume memory for long-running objects
- **Validation Cost**: State machine adds validation overhead

## References

- **Design Patterns**: Elements of Reusable Object-Oriented Software (Gang of Four)
- **Head First Design Patterns**
- **Refactoring Guru**: https://refactoring.guru/design-patterns/state
- **State Machine Design**: Various academic papers on formal state machines

## License

This implementation is part of the UIM (Universal Interface Manager) framework.
