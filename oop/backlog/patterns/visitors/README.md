# Visitor Pattern

## Overview

The Visitor pattern is a behavioral design pattern that lets you separate algorithms from the objects on which they operate. It allows you to add new operations to existing object structures without modifying those structures.

The pattern defines a visitor that can visit elements of an object structure and perform operations on them, while the elements themselves remain unchanged.

## Purpose

- **Separate operations from object structure** - Keep algorithms separate from the data
- **Add new operations easily** - Create new visitors without modifying element classes
- **Gather related operations** - Put similar operations in one visitor class
- **Operate on heterogeneous collections** - Visit different types of elements uniformly
- **Accumulate state during traversal** - Visitors can maintain state across visits

## UML Structure

```
┌───────────┐
│ IVisitor  │◄──────────┐
│ ┌───────┐ │           │
│ │visit()│ │           │
│ └───────┘ │           │accepts
└───────────┘           │
      △                 │
      │                 │
┌─────┴──────┐    ┌─────┴─────┐
│ConcreteVis1│    │ IElement  │
│  visit()   │    │ ┌───────┐ │
└────────────┘    │ │accept()││
                  │ └───────┘ │
┌────────────┐    └───────────┘
│ConcreteVis2│          △
│  visit()   │          │
└────────────┘    ┌─────┴──────┐
                  │ConcreteElem│
                  │  accept()  │
                  └────────────┘
```

## Components

### Core Interfaces

1. **IVisitor**: Declares visit operations for each concrete element type
   - `visit(element)`: Visits an element and performs an operation

2. **IElement**: Declares an accept method that accepts a visitor
   - `accept(visitor)`: Accepts a visitor and calls its visit method
   - `name()`: Returns the element identifier

3. **IGenericVisitor<TElement>**: Type-safe visitor for specific element types
   - `visit(element)`: Visits a typed element with compile-time safety

4. **IObjectStructure**: Manages a collection of elements
   - `addElement(element)`: Adds an element to the structure
   - `removeElement(element)`: Removes an element
   - `accept(visitor)`: Applies visitor to all elements
   - `elementCount()`: Returns the number of elements

5. **IVisitable**: Extended element interface with type information
   - `elementType()`: Returns the type identifier

6. **IAccumulatingVisitor<TResult>**: Visitor that collects results
   - `result()`: Returns the accumulated result
   - `reset()`: Resets the visitor's state

7. **IHierarchicalElement**: Element that can have children
   - `children()`: Returns child elements
   - `addChild(child)`: Adds a child element

### Concrete Implementations

1. **BaseElement**: Abstract element with common functionality
   - Stores element name
   - Provides base implementation

2. **BaseVisitor**: Abstract visitor with visit tracking
   - Tracks visited elements
   - Provides common functionality

3. **ObjectStructure**: Collection of elements
   - Manages element list
   - Applies visitors to all elements

## Real-World Examples

### 1. Shape Rendering System

Different operations on geometric shapes:

```d
auto circle = new Circle("C1", 5.0);
auto rectangle = new Rectangle("R1", 4.0, 3.0);

// Calculate areas
auto areaCalc = new AreaCalculator();
circle.accept(areaCalc);
rectangle.accept(areaCalc);
writeln("Total area: ", areaCalc.totalArea());

// Calculate perimeters
auto perimCalc = new PerimeterCalculator();
circle.accept(perimCalc);
rectangle.accept(perimCalc);

// Generate drawing commands
auto drawer = new DrawingVisitor();
circle.accept(drawer);
rectangle.accept(drawer);
```

**Visitors:** AreaCalculator, PerimeterCalculator, DrawingVisitor  
**Elements:** Circle, Rectangle, Triangle  
**Benefit:** Add new operations (export, transform, etc.) without modifying shape classes

### 2. File System Operations

Various operations on files and directories:

```d
auto root = new DirectoryElement("root");
auto file1 = new FileElement("data.txt", 1024);
root.addChild(file1);

// Calculate total size
auto sizeCalc = new SizeCalculator();
root.accept(sizeCalc);
writeln("Total: ", sizeCalc.totalSize(), " bytes");

// Count files and directories
auto counter = new FileCounter();
root.accept(counter);

// Generate file listing
auto lister = new FileLister();
root.accept(lister);
```

**Visitors:** SizeCalculator, FileCounter, FileLister  
**Elements:** FileElement, DirectoryElement  
**Use case:** File managers, backup tools, disk analyzers

### 3. Expression Evaluation

Evaluate mathematical expressions:

```d
// Expression: (5 + 3) * 2
auto expr = new MultiplyExpression(
    new AddExpression(
        new NumberExpression(5.0),
        new NumberExpression(3.0)
    ),
    new NumberExpression(2.0)
);

auto evaluator = new ExpressionEvaluator();
expr.accept(evaluator);
writeln("Result: ", evaluator.result()); // 16.0
```

**Visitors:** ExpressionEvaluator, ExpressionPrinter, ExpressionOptimizer  
**Elements:** NumberExpression, AddExpression, MultiplyExpression  
**Benefit:** Add new operations (printing, optimization) easily

## When to Use

Use the Visitor pattern when:

1. **Multiple Operations**: You need to perform many distinct operations on objects in a structure
2. **Stable Structure**: The object structure rarely changes, but operations change frequently
3. **Heterogeneous Collections**: You work with collections of different types
4. **Gather Operations**: You want to group related operations in one place
5. **Avoid Pollution**: You don't want to add operations to element classes

## When Not to Use

Avoid the Visitor pattern when:

1. **Changing Structure**: Element classes change frequently (requires updating all visitors)
2. **Simple Operations**: Operations are simple and don't justify the complexity
3. **Single Operation**: Only one operation is needed
4. **Encapsulation Issues**: Visitors need access to element internals

## Benefits

✅ **Open/Closed Principle**: Add new operations without modifying elements  
✅ **Single Responsibility**: Each visitor has one focused operation  
✅ **Gather Related Operations**: Group similar operations in visitor classes  
✅ **Accumulate State**: Visitors can maintain state across elements  
✅ **Operate Uniformly**: Handle different element types uniformly  
✅ **Easy Testing**: Test operations independently in visitor classes  

## Drawbacks

❌ **Adding New Elements**: Requires updating all visitor interfaces  
❌ **Breaking Encapsulation**: Visitors may need access to element internals  
❌ **Circular Dependencies**: Elements and visitors know about each other  
❌ **Complexity**: Adds indirection and additional classes  

## Double Dispatch

The Visitor pattern uses **double dispatch**:

1. Client calls `element.accept(visitor)` - first dispatch
2. Element calls `visitor.visit(this)` - second dispatch
3. Correct visitor method is called based on both element and visitor types

This allows method selection based on two object types at runtime.

## Visitor vs Strategy Pattern

| Aspect | Visitor | Strategy |
|--------|---------|----------|
| **Purpose** | Operations on object structure | Algorithm selection |
| **Structure** | Operates on heterogeneous elements | Single context with algorithms |
| **Adding operations** | Easy - new visitor | Easy - new strategy |
| **Adding types** | Hard - update all visitors | N/A |
| **State** | Can accumulate state | Typically stateless |
| **Relationship** | Elements accept visitors | Context has a strategy |

## Best Practices

1. **Keep Visitors Focused**: Each visitor should have one clear purpose
2. **Use Type Checking**: Cast elements safely with type checks
3. **Provide Base Classes**: BaseVisitor and BaseElement reduce duplication
4. **Document Requirements**: Clearly document what visitors can access
5. **Consider Privacy**: Use friend functions or accessors for private data
6. **Handle Unknown Types**: Gracefully handle unexpected element types
7. **Test Thoroughly**: Test each visitor with all element types
8. **Use Object Structures**: Group related elements for batch operations

## Implementation Variants

### 1. Classic Visitor
Separate visit method for each concrete element type (requires type-specific overloads).

### 2. Generic Visitor
Single generic visit method with runtime type checking (simpler but less type-safe).

### 3. Accumulating Visitor
Visitor that collects and returns results (AreaCalculator, SizeCalculator).

### 4. Hierarchical Visitor
Visitor that handles tree structures automatically (DirectoryElement example).

## Common Use Cases

1. **Compiler Design**: AST traversal, code generation, optimization
2. **File Systems**: Size calculation, search, listing, cleanup
3. **Graphics**: Rendering, hit testing, bounding box calculation
4. **Document Processing**: Formatting, exporting, validation
5. **Game Development**: Collision detection, rendering, AI behavior
6. **Database Systems**: Query optimization, execution, analysis
7. **UI Frameworks**: Layout calculation, event handling, rendering
8. **Scientific Computing**: Expression evaluation, differentiation, simplification

## Testing

The implementation includes comprehensive unit tests covering:

- Element creation and naming
- Object structure management (add/remove)
- Visitor tracking of visited elements
- Shape operations (area, perimeter, drawing)
- File system operations (size, counting, listing)
- Expression evaluation
- Complex nested structures
- Multiple visitors on same structure

Run tests with:
```bash
dub test
```

## Example Scenarios

### Code Analysis Tool

**Elements:** ClassNode, MethodNode, VariableNode  
**Visitors:**
- ComplexityCalculator: Measures cyclomatic complexity
- LineCounter: Counts lines of code
- DependencyAnalyzer: Finds dependencies
- DocumentGenerator: Creates documentation

### E-commerce System

**Elements:** Product, Category, Order  
**Visitors:**
- PriceCalculator: Calculates totals with tax
- InventoryChecker: Validates stock
- ShippingCalculator: Determines shipping costs
- ReportGenerator: Creates sales reports

### Graphics Editor

**Elements:** Circle, Rectangle, Line, Text  
**Visitors:**
- Renderer: Draws to screen
- BoundsCalculator: Computes bounding boxes
- HitTester: Checks mouse clicks
- Exporter: Saves to file formats

## Related Patterns

- **Composite**: Often used together (visitor traverses composite structures)
- **Iterator**: Similar traversal concept but different purpose
- **Command**: Can encapsulate visitor operations as commands
- **Strategy**: Similar structure but different intent
- **Interpreter**: Expression trees often use visitor for evaluation

## Anti-Patterns to Avoid

1. **God Visitor**: Visitor that does too many unrelated things
2. **Leaky Abstraction**: Exposing too much element internals
3. **Visitor Explosion**: Creating too many single-use visitors
4. **Brittle Structure**: Frequent element type changes
5. **Missing Null Checks**: Not handling null elements safely

## Performance Considerations

- **Virtual Dispatch**: Two virtual method calls per visit (accept + visit)
- **Type Checking**: Runtime type checks with casts (if using generic approach)
- **Memory**: Visitor state accumulation can use memory
- **Traversal**: Efficient for bulk operations, overhead for single operations

## Advanced Techniques

### Visitor Chaining
Apply multiple visitors in sequence:
```d
structure.accept(visitor1);
structure.accept(visitor2);
structure.accept(visitor3);
```

### Filtering Visitors
Visitors that only operate on specific element types.

### Transforming Visitors
Visitors that modify or replace elements during traversal.

### Parallel Visitors
Independent visitors can process elements concurrently.

## References

- **Design Patterns**: Elements of Reusable Object-Oriented Software (Gang of Four)
- **Head First Design Patterns**
- **Refactoring Guru**: https://refactoring.guru/design-patterns/visitor
- **Martin Fowler**: Refactoring and patterns

## License

This implementation is part of the UIM (Universal Interface Manager) framework.
