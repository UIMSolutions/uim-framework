# Flyweight Pattern

## Overview
The Flyweight Pattern is a structural design pattern that minimizes memory usage by sharing as much data as possible with similar objects. It's particularly useful when dealing with large numbers of objects that share common state.

## Intent
- Use sharing to support large numbers of fine-grained objects efficiently
- Minimize memory usage by sharing common data
- Separate intrinsic (shared) state from extrinsic (unique) state
- Reduce the total number of object instances

## Key Concepts

### Intrinsic State
- **Shared among objects**: Stored in the flyweight and shared
- **Context-independent**: Doesn't change with different contexts
- **Immutable**: Should not change after creation
- **Examples**: Character glyph, tree type, texture data

### Extrinsic State
- **Unique to each object**: Passed to flyweight operations
- **Context-dependent**: Varies with each use
- **Stored externally**: Kept by client or context
- **Examples**: Position, color, size variations

## Components

### Interfaces
- **IFlyweight**: Basic flyweight interface accepting extrinsic state
- **IGenericFlyweight<T>**: Type-safe flyweight for specific extrinsic types
- **IFlyweightFactory<T>**: Factory for managing flyweight instances
- **IMemoryReportable**: Interface for memory usage reporting

### Implementations
- **ConcreteFlyweight**: Flyweight storing intrinsic state
- **UnsharedConcreteFlyweight**: Flyweight that isn't shared
- **GenericFlyweight<T>**: Generic typed flyweight
- **FlyweightFactory**: Factory managing concrete flyweights
- **GenericFlyweightFactory<T, TExtrinsic>**: Generic factory

### Real-World Examples
1. **Character Rendering System**:
   - **CharacterGlyph**: Shared glyph data (intrinsic)
   - **CharacterContext**: Position and color (extrinsic)
   - **GlyphFactory**: Manages shared glyphs
   - **TextDocument**: Uses flyweights for text rendering

2. **Forest Rendering System**:
   - **TreeType**: Shared tree properties (intrinsic)
   - **Tree**: Position and height (extrinsic)
   - **TreeFactory**: Manages tree types
   - **Forest**: Collection of trees using shared types

## When to Use

### Good Use Cases
1. **Large number of objects**: When you need many similar objects
2. **High memory usage**: When object creation is expensive in memory
3. **Shared state exists**: When objects share significant common data
4. **Extrinsic state can be computed**: When unique state can be derived or passed
5. **Object identity not important**: When objects don't need unique identity

### Perfect Scenarios
- Text editors (character glyphs)
- Game development (sprites, particles, terrain tiles)
- Graphics systems (shared textures, meshes)
- Document formatting (shared styles, fonts)
- UI systems (shared widgets, icons)
- Database connection pools

### Benefits
- **Dramatic memory reduction**: Can reduce memory by 90%+ in some cases
- **Performance improvement**: Fewer objects = better cache performance
- **Faster creation**: Reusing objects is faster than creating new ones
- **Scalability**: Enables handling of much larger datasets

### Drawbacks
- **Added complexity**: Need to manage intrinsic vs extrinsic state
- **Runtime overhead**: Factory lookups add small overhead
- **Thread safety**: Shared objects need synchronization in concurrent scenarios
- **Design constraints**: Must carefully separate shared/unique state

## Examples

### Basic Flyweight
```d
auto factory = new FlyweightFactory();
auto fw1 = factory.getFlyweight("SharedState");
auto fw2 = factory.getFlyweight("SharedState"); // Reuses fw1

assert(fw1 is fw2); // Same object!

string result1 = fw1.operation("Context1");
string result2 = fw1.operation("Context2");
```

### Text Document
```d
auto doc = new TextDocument();

// Add many characters
foreach (c; "Hello World!") {
    doc.addCharacter(c, x, y, "black", "Arial", 12);
    x += 10;
}

// 12 characters, but only ~9 unique glyphs (l appears 3 times)
writeln("Characters: ", doc.characterCount());      // 12
writeln("Unique glyphs: ", doc.uniqueGlyphCount()); // ~9
```

### Forest Simulation
```d
auto forest = new Forest();

// Plant 1000 oak trees - all share same TreeType!
foreach (i; 0..1000) {
    forest.plantTree(x, y, height, "Oak", "Green", "oak.png");
}

writeln("Trees: ", forest.treeCount());           // 1000
writeln("Types: ", forest.uniqueTreeTypes());     // 1
// Only 1 TreeType object for 1000 trees!
```

### Memory Comparison
```d
// WITHOUT Flyweight:
// 10,000 characters × 200 bytes = 2,000,000 bytes

// WITH Flyweight:
// 10,000 contexts × 20 bytes = 200,000 bytes
// 50 glyphs × 200 bytes = 10,000 bytes
// Total: 210,000 bytes (~90% reduction!)
```

## Real-World Scenarios

1. **Text Editors**
   - Millions of characters, few unique glyphs
   - Share font rendering data
   - Each character has position/color

2. **Game Development**
   - Thousands of sprites with same texture
   - Particle systems with shared properties
   - Terrain tiles sharing texture data

3. **Graphics Applications**
   - Shared mesh/texture data
   - Instanced rendering
   - Icon libraries

4. **Document Systems**
   - Shared paragraph styles
   - Font libraries
   - Template systems

5. **Web Applications**
   - Cached DOM elements
   - Shared CSS styles
   - Icon sprite sheets

## Implementation Notes

### D Language Specifics
- Uses `@safe` annotations for memory safety
- Leverages associative arrays for fast lookup
- Generic implementations using templates
- Can use `immutable` for true thread-safe sharing
- Interface-based design for flexibility

### Best Practices

1. **Identify Shared State**:
   - Look for data that's identical across many objects
   - This becomes intrinsic state in the flyweight

2. **Externalize Unique State**:
   - Data that varies per instance
   - Pass as parameters to operations

3. **Use Factory Pattern**:
   - Centralize flyweight creation
   - Ensure sharing and prevent duplicates

4. **Consider Thread Safety**:
   - Make intrinsic state `immutable` if possible
   - Synchronize factory access if needed

5. **Measure Memory Impact**:
   - Profile before and after
   - Ensure the pattern actually helps

6. **Document Clearly**:
   - Make it obvious which state is shared
   - Document factory usage patterns

### Performance Considerations

**Memory Savings**:
```
Without Flyweight: N × (intrinsic_size + extrinsic_size)
With Flyweight: (unique_types × intrinsic_size) + (N × extrinsic_size)

Savings = N × intrinsic_size - (unique_types × intrinsic_size)
        = intrinsic_size × (N - unique_types)
```

**Best when**: N >> unique_types (many objects, few types)

**Trade-offs**:
- Small factory lookup cost
- Minimal for most use cases
- Vastly outweighed by memory savings

## Related Patterns

- **Factory**: Used to create and manage flyweights
- **Composite**: Can use flyweights for leaf nodes
- **State/Strategy**: Can be implemented as flyweights
- **Singleton**: Similar sharing concept, but for single instance
- **Object Pool**: Reuses objects, but different purpose

## Common Pitfalls

1. **Over-application**: Not all objects benefit from flyweight
2. **Mutable shared state**: Defeats the purpose and causes bugs
3. **Ignoring thread safety**: Shared objects need synchronization
4. **Complex extrinsic state**: If extrinsic state is too large, benefits diminish
5. **Premature optimization**: Apply when you have proven memory issues

## Testing Flyweights

```d
@safe unittest {
    auto factory = new FlyweightFactory();
    
    auto fw1 = factory.getFlyweight("A");
    auto fw2 = factory.getFlyweight("A");
    
    // Verify sharing
    assert(fw1 is fw2, "Should be same instance");
    
    // Verify different extrinsic states work
    assert(fw1.operation("ctx1") != fw1.operation("ctx2"));
}
```

## Summary

The Flyweight Pattern is essential when:
- You have many similar objects
- Memory is a concern
- Objects share significant common state
- Performance matters

It's one of the most effective optimization patterns when applied correctly, potentially reducing memory usage by 90% or more in suitable scenarios.
