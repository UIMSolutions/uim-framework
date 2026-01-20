# Chain of Responsibility Pattern

## Purpose
The Chain of Responsibility Pattern is a behavioral design pattern that lets you pass requests along a chain of handlers. Upon receiving a request, each handler decides either to process the request or to pass it to the next handler in the chain. This pattern promotes loose coupling by allowing multiple objects to handle a request without the sender knowing which object will ultimately process it.

## Problem It Solves
- **Tight Coupling**: When the sender of a request is tightly coupled to specific receivers
- **Dynamic Processing**: When the set of handlers and their order should be determined at runtime
- **Multiple Handlers**: When more than one object can handle a request, and the handler isn't known in advance
- **Request Escalation**: When requests should be escalated through a hierarchy until handled
- **Flexible Pipeline**: When you need a flexible processing pipeline that can be easily modified

## UML Class Diagram
```
┌────────────────┐
│  <<interface>> │
│    IHandler    │
├────────────────┤
│ + setNext()    │
│ + handle()     │
└────────▲───────┘
         │
         │ implements
         │
┌────────┴────────┐
│   BaseHandler   │
├─────────────────┤
│ - _nextHandler  │
├─────────────────┤
│ + setNext()     │
│ + handle()      │
└────────▲────────┘
         │
         │ extends
         │
┌────────┴─────────┐
│ ConcreteHandler  │
├──────────────────┤
│ + handle()       │
└──────────────────┘

Client ──► IHandler ──next──► IHandler ──next──► IHandler
           Handler1            Handler2            Handler3
```

## Components

### 1. IHandler
The handler interface declaring methods for setting the next handler and processing requests.
```d
interface IHandler {
    IHandler setNext(IHandler handler);
    string handle(string request);
}
```

### 2. BaseHandler
Abstract base class implementing the chain mechanism.
```d
abstract class BaseHandler : IHandler {
    protected IHandler _nextHandler;
    
    IHandler setNext(IHandler handler) {
        _nextHandler = handler;
        return handler;
    }
    
    string handle(string request) {
        if (_nextHandler !is null) {
            return _nextHandler.handle(request);
        }
        return null;
    }
}
```

### 3. ConditionalHandler
Handler with filtering capability.
```d
abstract class ConditionalHandler : BaseHandler {
    override string handle(string request) {
        if (shouldHandle(request)) {
            return doHandle(request);
        }
        return super.handle(request);
    }
    
    abstract bool shouldHandle(string request);
    protected abstract string doHandle(string request);
}
```

### 4. ChainBuilder
Builder for constructing handler chains.
```d
class ChainBuilder : IChainBuilder {
    IChainBuilder addHandler(IHandler handler);
    IHandler build();
}
```

### 5. IChainCoordinator
Manages multiple named chains.
```d
interface IChainCoordinator {
    void registerChain(string name, IHandler handler);
    string processRequest(string chainName, string request);
    bool hasChain(string name) const;
}
```

## Real-World Examples

### Example 1: Support Ticket System
A customer support system with escalation levels:
```d
auto level1 = new Level1Support();
auto level2 = new Level2Support();
auto level3 = new Level3Support();
auto manager = new ManagerEscalation();

level1.setNext(level2).setNext(level3).setNext(manager);

// Basic issue - handled by Level 1
auto result1 = level1.handle("password reset needed");
// "Level 1 Support: Handled - password reset needed"

// Technical issue - escalated to Level 2
auto result2 = level1.handle("technical bug in system");
// "Level 2 Support: Handled - technical bug in system"

// Critical issue - escalated to Level 3
auto result3 = level1.handle("critical server outage");
// "Level 3 Support: Handled - critical server outage"
```

**Key Features:**
- Automatic escalation based on issue type
- Each level handles specific categories
- Unhandled requests escalate to management
- Flexible addition of new support levels

### Example 2: Purchase Approval Workflow
An organizational purchase approval system:
```d
auto teamLead = new TeamLeadApproval();
auto manager = new ManagerApproval();
auto director = new DirectorApproval();

teamLead.setNext(manager).setNext(director);

// Small purchase - team lead approves
auto r1 = teamLead.handle("Purchase: $500");
// "Team Lead approved: Purchase: $500"

// Medium purchase - requires manager
auto r2 = teamLead.handle("Purchase: $3000");
// "Manager approved: Purchase: $3000"

// Large purchase - requires director
auto r3 = teamLead.handle("Purchase: $15000");
// "Director approved: Purchase: $15000"
```

**Key Features:**
- Approval authority based on amount
- Hierarchical approval structure
- Automatic routing to appropriate level
- Clear audit trail

### Example 3: HTTP Request Pipeline
Middleware-style request processing:
```d
auto auth = new AuthenticationHandler();
auto authz = new AuthorizationHandler();
auto validator = new ValidationHandler();
auto processor = new ProcessingHandler();

auth.setNext(authz).setNext(validator).setNext(processor);

// Each handler processes specific aspects
auto result = auth.handle("auth:token role:admin validate:data");
// Request flows through: auth → authz → validation → processing
```

**Key Features:**
- Authentication verification
- Authorization checks
- Request validation
- Final request processing
- Early exit on failure

## Benefits

1. **Decoupling**: Sender doesn't need to know which receiver handles the request
2. **Flexibility**: Chain can be modified at runtime
3. **Single Responsibility**: Each handler has one specific purpose
4. **Dynamic Routing**: Requests automatically route to appropriate handler
5. **Easy Extension**: New handlers can be added without modifying existing code
6. **Scalability**: Support for complex processing pipelines

## When to Use

- When more than one object can handle a request, and the handler isn't known beforehand
- When you want to issue a request to one of several objects without specifying the receiver explicitly
- When the set of objects that can handle a request should be specified dynamically
- When you need to execute several handlers in a specific order
- When you want to implement request escalation or fallback mechanisms
- When building middleware or plugin systems

## When Not to Use

- When every request must be handled (consider using Command pattern instead)
- When the chain becomes too long, affecting performance
- When the order of handlers is critical and complex (consider Strategy pattern)
- When debugging is difficult due to complex chains

## Implementation Considerations

### 1. Return Value or Pass Through
Decide whether handlers return a value or modify the request:
```d
// Return value approach
string handle(string request) {
    if (canHandle(request)) {
        return processRequest(request);
    }
    return super.handle(request);
}

// Pass through approach (modify request)
string handle(string request) {
    request = preProcess(request);
    return super.handle(request);
}
```

### 2. Chain Termination
Determine what happens when no handler processes the request:
```d
// Return null
string handle(string request) {
    if (_nextHandler !is null) {
        return _nextHandler.handle(request);
    }
    return null; // No handler processed it
}

// Throw exception
string handle(string request) {
    if (_nextHandler !is null) {
        return _nextHandler.handle(request);
    }
    throw new UnhandledRequestException(request);
}

// Use fallback handler
class FallbackHandler : BaseHandler {
    override string handle(string request) {
        return "Default: " ~ request;
    }
}
```

### 3. Conditional Processing
Use conditional handlers for filtering:
```d
abstract class ConditionalHandler : BaseHandler {
    override string handle(string request) {
        if (shouldHandle(request)) {
            return doHandle(request);
        }
        return super.handle(request);
    }
    
    abstract bool shouldHandle(string request);
    protected abstract string doHandle(string request);
}
```

### 4. Chain Building
Use builder pattern for complex chains:
```d
auto builder = new ChainBuilder();
auto chain = builder
    .addHandler(new Handler1())
    .addHandler(new Handler2())
    .addHandler(new Handler3())
    .build();
```

## Advanced Features

### 1. Logging Handlers
Track request flow through the chain:
```d
class LoggingHandler : BaseHandler, ILoggingHandler {
    private string[] _log;
    
    override string handle(string request) {
        _log ~= "Received: " ~ request;
        auto result = super.handle(request);
        if (result !is null) {
            _log ~= "Result: " ~ result;
        }
        return result;
    }
}
```

### 2. Priority-Based Handling
Handlers with priority levels:
```d
interface IPriorityHandler : IHandler {
    int priority() const;
}

// Sort handlers by priority before building chain
handlers.sort!((a, b) => a.priority() > b.priority());
```

### 3. Chain Coordinator
Manage multiple independent chains:
```d
auto coordinator = new ChainCoordinator();
coordinator.registerChain("support", supportChain);
coordinator.registerChain("sales", salesChain);
coordinator.registerChain("technical", techChain);

coordinator.processRequest("support", "help needed");
```

### 4. Generic Handlers
Type-safe handlers with generic requests/responses:
```d
interface IGenericHandler(TRequest, TResponse) {
    IGenericHandler!(TRequest, TResponse) setNext(...);
    TResponse handle(TRequest request);
    bool canHandle(TRequest request);
}
```

## Comparison with Other Patterns

### Chain of Responsibility vs Command
- **Chain**: Multiple handlers, one may process the request
- **Command**: Single receiver for each command

### Chain of Responsibility vs Decorator
- **Chain**: Handlers can stop propagation
- **Decorator**: All decorators always execute

### Chain of Responsibility vs Observer
- **Chain**: Sequential processing, one handler responds
- **Observer**: Parallel processing, all observers notified

## Best Practices

1. **Clear Termination**: Always handle the case when no handler processes the request
2. **Order Matters**: Place more specific handlers before general ones
3. **Avoid Long Chains**: Too many handlers can impact performance
4. **Immutable Requests**: Consider making requests immutable to prevent side effects
5. **Use Builders**: For complex chains, use builder pattern
6. **Document Flow**: Clearly document the expected request flow
7. **Testing**: Test each handler independently and the complete chain
8. **Logging**: Add logging to track request flow for debugging

## Common Pitfalls

1. **Unhandled Requests**: Forgetting to handle the case when no handler processes the request
2. **Circular Chains**: Creating circular references in the chain
3. **Order Dependency**: Incorrect handler order leading to wrong behavior
4. **Performance**: Long chains with many handlers can be slow
5. **Debugging Difficulty**: Hard to trace which handler processed the request
6. **Missing Fallback**: No default handler for unprocessed requests

## Testing Strategy

1. **Individual Handlers**: Test each handler in isolation
2. **Chain Flow**: Verify requests flow correctly through the chain
3. **Termination**: Test behavior when no handler processes the request
4. **Order Sensitivity**: Test with different handler orders
5. **Edge Cases**: Empty chains, single handler chains
6. **Logging**: Verify logging handlers track correctly

## Performance Considerations

### Time Complexity
- Best case: O(1) - first handler processes the request
- Worst case: O(n) - request passes through all n handlers
- Average: Depends on chain length and request distribution

### Space Complexity
- O(n) for storing n handlers in the chain
- O(1) per handler for storing next reference

### Optimization Tips
- Place frequently matched handlers early in the chain
- Use conditional handlers to filter efficiently
- Consider caching for expensive checks
- Limit chain length for performance-critical paths

## Related Patterns

- **Command**: Can be used with Chain for undo/redo with escalation
- **Composite**: Handlers can be composites of other handlers
- **Decorator**: Similar structure but different semantics
- **Strategy**: Alternative when you need to select one algorithm
- **Template Method**: Can be used within handler implementations

## See Also
- [Command Pattern](../commands/README.md)
- [Strategy Pattern](../strategies/README.md)
- [Decorator Pattern](../decorators/README.md)
- [Observer Pattern](../observers/README.md)
