# Prototype Pattern

## Overview
The Prototype Pattern is a creational design pattern that allows you to create new objects by cloning existing ones, without coupling to their specific classes. This pattern delegates the cloning process to the actual objects being cloned.

## Intent
- Specify the kinds of objects to create using a prototypical instance
- Create new objects by copying this prototype
- Avoid the cost of creating objects from scratch when copies are cheaper

## Components

### Interfaces
- **IPrototype<T>**: Base interface defining the `clone()` method
- **IDeepCloneable<T>**: Interface for deep cloning (clones referenced objects too)
- **IShallowCloneable<T>**: Interface for shallow cloning (copies references only)
- **IPrototypeRegistry<T>**: Interface for managing prototype objects

### Implementations
- **Prototype<T>**: Abstract base class for prototypical objects
- **ConcretePrototype**: Simple prototype with primitive data
- **ComplexPrototype**: Prototype demonstrating deep vs shallow cloning
- **PrototypeRegistry<T>**: Registry for storing and cloning prototypes
- **ConfigPrototype**: Specialized prototype for configuration objects

## When to Use

### Good Use Cases
1. **Object creation is expensive**: When creating objects from scratch is costly
2. **Similar objects needed**: When you need many objects with similar properties
3. **Configuration variants**: Creating variants of configuration objects
4. **Dynamic object creation**: When object types are determined at runtime
5. **Avoiding subclass explosion**: Reduce the number of subclasses needed
6. **Undoable operations**: Store object states for undo functionality

### Benefits
- Reduces the need for subclassing
- Hides complexity of object creation
- Allows adding/removing objects at runtime
- Specifies new objects by varying values
- Reduces initialization code

### Drawbacks
- Cloning complex objects with circular references can be tricky
- Deep cloning can be complicated to implement correctly
- Each prototype class must implement the clone operation

## Examples

### Basic Cloning
```d
auto original = new ConcretePrototype(1, "Product", 99.99);
auto clone = original.clone();
clone.id = 2;  // Modify independently
```

### Prototype Registry
```d
auto registry = new PrototypeRegistry!ConcretePrototype();

// Register templates
registry.register("basic", new ConcretePrototype(0, "Basic", 9.99));
registry.register("premium", new ConcretePrototype(0, "Premium", 99.99));

// Create instances
auto product1 = registry.create("basic");
auto product2 = registry.create("premium");
```

### Deep vs Shallow Cloning
```d
auto original = new ComplexPrototype("data", [1, 2, 3]);

// Deep clone - independent copy
auto deepCopy = original.deepClone();
deepCopy.data[0] = 999;  // Won't affect original

// Shallow clone - shared references
auto shallowCopy = original.shallowClone();
shallowCopy.data[0] = 999;  // Will affect original
```

### Configuration Management
```d
auto registry = new PrototypeRegistry!ConfigPrototype();
auto baseConfig = new ConfigPrototype("base", 8080, false);
registry.register("base", baseConfig);

// Create environment variants
auto devConfig = registry.create("base");
devConfig.environment = "development";
devConfig.debug = true;

auto prodConfig = registry.create("base");
prodConfig.environment = "production";
```

## Real-World Scenarios

1. **Document Templates**: Word processor with document templates
2. **Game Development**: Cloning game entities/characters
3. **GUI Builders**: Cloning UI components
4. **Database Records**: Creating similar database entries
5. **Test Data**: Generating test objects with slight variations
6. **Caching**: Cloning cached objects instead of recreating

## Related Patterns
- **Abstract Factory**: Can use prototypes to implement factory methods
- **Composite**: Often used together; cloning complex structures
- **Decorator**: Prototypes can be decorated
- **Memento**: Prototypes can be used to save/restore state

## Implementation Notes

### D Language Specifics
- Uses templates for type safety
- Distinguishes between deep and shallow cloning
- Provides registry for prototype management
- Uses `@safe` annotations for memory safety
- Leverages D's `.dup` for array/AA copying

### Best Practices
1. Consider whether deep or shallow cloning is needed
2. Be careful with mutable references in shallow clones
3. Use registry pattern for managing multiple prototypes
4. Document cloning behavior clearly
5. Handle circular references appropriately
6. Consider serialization for complex cloning scenarios
