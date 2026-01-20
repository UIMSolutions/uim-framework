# Bridge Pattern

## Overview
The Bridge Pattern is a structural design pattern that decouples an abstraction from its implementation so that the two can vary independently. It uses composition over inheritance to separate the interface from the implementation.

## Intent
- Decouple an abstraction from its implementation
- Allow both abstraction and implementation to vary independently
- Avoid a permanent binding between abstraction and implementation
- Share implementations among multiple abstractions

## Components

### Interfaces
- **IImplementor**: Defines the interface for implementation classes
- **IBridgeAbstraction**: Defines the interface for the abstraction side
- **IExtendedAbstraction**: Extended abstraction with additional operations
- **IGenericImplementor<T>**: Generic implementor for type-specific operations
- **IGenericAbstraction<T>**: Generic abstraction working with typed implementors

### Implementations
- **BridgeAbstraction**: Abstract base class maintaining implementor reference
- **ExtendedAbstraction**: Extended abstraction with additional functionality
- **RefinedAbstraction**: Refined abstraction with specific behavior
- **ConcreteImplementorA/B**: Concrete implementor classes
- **GenericAbstraction<T>**: Generic abstraction implementation
- **CachingAbstraction<T>**: Refined abstraction with caching capability
- **StringProcessorImpl/IntProcessorImpl**: Generic implementors for common types

### Real-World Example
- **IPlatform**: Platform interface (Windows, Linux)
- **Device**: Abstract device class
- **RemoteControl/AdvancedRemote**: Concrete device abstractions

## When to Use

### Good Use Cases
1. **Avoid permanent binding**: When you want to avoid compile-time binding between abstraction and implementation
2. **Both vary independently**: When both abstraction and implementation should be extensible by subclassing
3. **Implementation sharing**: When you want to share implementations among multiple objects
4. **Platform independence**: When implementing platform-independent classes
5. **Hide implementation**: When you want to hide implementation details from clients
6. **Multiple dimensions of variation**: When you have orthogonal class hierarchies

### Benefits
- Decouples interface from implementation
- Improves extensibility (add abstractions and implementations independently)
- Hides implementation details from clients
- Enables platform independence
- Reduces the number of subclasses needed
- Allows runtime binding of implementation

### Drawbacks
- Increases complexity due to additional indirection
- Requires careful design to identify proper abstractions
- Can make code harder to understand initially

## Examples

### Basic Bridge
```d
auto implA = new ConcreteImplementorA();
auto abstraction = new BridgeAbstraction(implA);
string result = abstraction.operation();

// Switch implementation at runtime
auto implB = new ConcreteImplementorB();
abstraction.implementor = implB;
result = abstraction.operation();
```

### Generic Processing
```d
auto upperProcessor = new StringProcessorImpl("Upper", 
    (string s) => s.toUpper());
auto abstraction = new GenericAbstraction!string(upperProcessor);

string result = abstraction.execute("hello"); // "HELLO"

// Switch to different processor
auto lowerProcessor = new StringProcessorImpl("Lower", 
    (string s) => s.toLower());
abstraction.implementor = lowerProcessor;
result = abstraction.execute("HELLO"); // "hello"
```

### Caching Abstraction
```d
auto processor = new IntProcessorImpl("Square", (int x) => x * x);
auto caching = new CachingAbstraction!int(processor);

int result1 = caching.execute(5); // Computed: 25
int result2 = caching.execute(5); // Cached: 25

caching.clearCache();
int result3 = caching.execute(5); // Computed again: 25
```

### Cross-Platform UI
```d
auto windowsPlatform = new WindowsPlatform();
auto linuxPlatform = new LinuxPlatform();

auto remote = new RemoteControl("TV", windowsPlatform);
string windowsUI = remote.render(); // Windows-style UI

remote.platform = linuxPlatform;
string linuxUI = remote.render(); // Linux-style UI
```

### Advanced Remote
```d
auto platform = new WindowsPlatform();
auto advanced = new AdvancedRemote("Smart TV", platform);

string ui = advanced.render(); // Basic + advanced controls
string settings = advanced.renderSettings(); // Settings panel
```

## Real-World Scenarios

1. **GUI Frameworks**: Separate GUI logic from platform-specific rendering
2. **Database Drivers**: Abstract database operations from specific DB implementations
3. **Graphics APIs**: Separate graphics operations from rendering backends (OpenGL, DirectX, Vulkan)
4. **Device Drivers**: Abstract device operations from hardware-specific implementations
5. **Persistence Layer**: Separate business objects from storage mechanisms
6. **Message Handling**: Abstract message format from transport protocol

## Related Patterns
- **Abstract Factory**: Can create and configure bridges
- **Adapter**: Changes interface of existing object; Bridge separates interface from implementation
- **State**: Can be implemented using Bridge for state-specific behavior
- **Strategy**: Similar structure but different intent (algorithm selection vs abstraction/implementation separation)

## Bridge vs Adapter

| Bridge | Adapter |
|--------|---------|
| Designed upfront | Applied to existing systems |
| Separates abstraction from implementation | Makes incompatible interfaces work together |
| Both sides can vary independently | Wraps existing interface |
| Used for new designs | Used for legacy integration |

## Implementation Notes

### D Language Specifics
- Uses interfaces for both abstraction and implementation sides
- Leverages templates for generic implementations
- Supports runtime implementor switching
- Uses delegates for flexible processors
- Provides both class-based and generic variants

### Best Practices
1. Identify abstraction and implementation dimensions early
2. Design interfaces for both sides independently
3. Use composition to connect abstraction to implementation
4. Allow runtime switching of implementations
5. Keep abstractions focused on high-level operations
6. Keep implementors focused on platform-specific details
7. Consider using factories to create bridges
8. Document which implementations work with which abstractions

### Performance Considerations
- Adds one level of indirection (virtual call)
- Minimal overhead for simple operations
- Consider caching for expensive operations
- Template versions may be optimized by compiler
