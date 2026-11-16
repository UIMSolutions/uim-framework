# Composite Pattern

The Composite pattern lets you compose objects into tree structures to represent part-whole hierarchies. It allows clients to treat individual objects and compositions of objects uniformly.

## Features

- **Uniform Interface**: Treat individual objects and compositions the same way
- **Tree Structures**: Build hierarchical object structures
- **Recursive Composition**: Composites can contain other composites
- **Tree Operations**: Find, traverse, depth calculation
- **Type Safety**: Strongly typed components and composites
- **Helper Functions**: Convenient factory methods

## Basic Usage

### Creating Leaves and Composites

```d
import uim.oop;

// Create leaf components (no children)
auto leaf1 = createLeaf("Leaf1", "Value1");
auto leaf2 = createLeaf("Leaf2", "Value2");

// Create composite (can have children)
auto composite = createComposite("Parent");
composite.add(leaf1);
composite.add(leaf2);

// Execute the entire structure
writeln(composite.execute()); // "Value1, Value2"
```

### Building Tree Structures

```d
// Create a tree
auto root = createTree("Root");

// Add leaves
root.add(createLeaf("Item1", "A"));
root.add(createLeaf("Item2", "B"));

// Add nested composite
auto branch = createComposite("Branch");
branch.add(createLeaf("Item3", "C"));
branch.add(createLeaf("Item4", "D"));
root.add(branch);

// Tree operations
writeln("Nodes: ", root.nodeCount());  // 6
writeln("Depth: ", root.depth());      // 3

// Find component by name
auto found = root.find("Item3");
if (found !is null) {
    writeln("Found: ", found.name());
}
```

### Traversing the Tree

```d
auto tree = createTree("Root");
tree.add(createLeaf("A", "1"));

auto branch = createComposite("Branch");
branch.add(createLeaf("B", "2"));
tree.add(branch);

// Depth-first traversal
tree.traverse((component) {
    writeln("Visiting: ", component.name());
});
```

## Real-World Examples

### File System

```d
class File : Leaf {
    private size_t _size;
    
    this(string name, size_t size) {
        super(name, name);
        _size = size;
    }
    
    size_t size() { return _size; }
}

class Directory : Composite {
    this(string name) {
        super(name);
    }
    
    size_t totalSize() {
        size_t total = 0;
        foreach (child; _children) {
            if (auto file = cast(File) child) {
                total += file.size();
            } else if (auto dir = cast(Directory) child) {
                total += dir.totalSize();
            }
        }
        return total;
    }
}

// Build file system
auto root = new Directory("root");
auto docs = new Directory("documents");
docs.add(new File("resume.pdf", 150));
docs.add(new File("letter.doc", 80));
root.add(docs);

writeln("Total size: ", root.totalSize(), " KB");
```

### Organization Structure

```d
class Employee : Leaf {
    private double _salary;
    
    this(string name, double salary) {
        super(name, name);
        _salary = salary;
    }
    
    double salary() { return _salary; }
}

class Department : Composite {
    this(string name) {
        super(name);
    }
    
    double totalBudget() {
        double total = 0;
        foreach (child; _children) {
            if (auto emp = cast(Employee) child) {
                total += emp.salary();
            } else if (auto dept = cast(Department) child) {
                total += dept.totalBudget();
            }
        }
        return total;
    }
}

// Build organization
auto company = new Department("TechCorp");
auto engineering = new Department("Engineering");
engineering.add(new Employee("Alice", 120000));
engineering.add(new Employee("Bob", 90000));
company.add(engineering);

writeln("Budget: $", company.totalBudget());
```

### Menu System

```d
class MenuItem : Leaf {
    this(string name, string action) {
        super(name, action);
    }
}

class Menu : Composite {
    this(string name) {
        super(name);
    }
}

// Build menu
auto mainMenu = new Menu("Main Menu");

auto fileMenu = new Menu("File");
fileMenu.add(new MenuItem("New", "Create file"));
fileMenu.add(new MenuItem("Open", "Open file"));
fileMenu.add(new MenuItem("Save", "Save file"));

mainMenu.add(fileMenu);
mainMenu.add(new Menu("Edit"));
mainMenu.add(new Menu("Help"));
```

### Graphics System

```d
class Shape : Leaf {
    this(string name, string type) {
        super(name, type);
    }
}

class Group : Composite {
    this(string name) {
        super(name);
    }
}

// Build graphics scene
auto scene = new Group("Scene");

auto background = new Group("Background");
background.add(new Shape("Sky", "Rectangle"));
background.add(new Shape("Ground", "Rectangle"));

auto foreground = new Group("Foreground");
foreground.add(new Shape("Tree", "Circle"));
foreground.add(new Shape("House", "Rectangle"));

scene.add(background);
scene.add(foreground);
```

## Component Operations

### Adding and Removing

```d
auto composite = createComposite("Parent");
auto child1 = createLeaf("Child1", "A");
auto child2 = createLeaf("Child2", "B");

composite.add(child1);
composite.add(child2);
writeln("Children: ", composite.childCount()); // 2

composite.remove(child1);
writeln("Children: ", composite.childCount()); // 1

composite.clear();
writeln("Children: ", composite.childCount()); // 0
```

### Accessing Children

```d
auto composite = createComposite("Parent");
composite.add(createLeaf("A", "1"));
composite.add(createLeaf("B", "2"));
composite.add(createLeaf("C", "3"));

// Get by index
auto child = composite.getChild(0);

// Get all children
auto children = composite.children();
foreach (child; children) {
    writeln(child.name());
}
```

### Type Checking

```d
IComponent component = createComposite("Test");

if (component.isComposite()) {
    auto composite = cast(IComposite) component;
    // Can add children
    composite.add(createLeaf("Child", "Value"));
}
```

## Benefits

1. **Uniform Treatment**: Treat simple and complex objects uniformly
2. **Open/Closed Principle**: Easy to add new component types
3. **Recursive Composition**: Build complex trees from simple parts
4. **Simplifies Client Code**: Clients don't need to distinguish between leaves and composites
5. **Flexible Structure**: Easy to add/remove components at runtime

## When to Use

- Represent part-whole hierarchies
- Want clients to ignore difference between compositions and individual objects
- Need to build tree-like structures
- Want to apply operations uniformly across a structure

## Pattern Comparison

| Pattern | Purpose | Structure |
|---------|---------|-----------|
| Composite | Part-whole hierarchies | Tree |
| Decorator | Add responsibilities | Linear chain |
| Strategy | Interchangeable algorithms | Single object |
| Facade | Simplified interface | Flat |

## Combining Patterns

**Composite + Iterator**:
```d
// Iterate through all components
tree.traverse((component) {
    // Process each component
});
```

**Composite + Visitor**:
```d
class ComponentVisitor : IComponentVisitor {
    void visit(IComponent component) {
        // Visit logic
    }
}

tree.accept(new ComponentVisitor());
```

**Composite + Strategy**:
```d
// Different execution strategies for composites
class CustomComposite : Composite {
    override string execute() {
        // Custom execution strategy
    }
}
```

## Advanced Features

### Custom Tree Operations

```d
auto tree = createTree("Root");
// ... add components ...

// Count total nodes
writeln("Total nodes: ", tree.nodeCount());

// Get tree depth
writeln("Depth: ", tree.depth());

// Find by name
auto found = tree.find("SpecificNode");
```

### Visitor Pattern Integration

```d
class PrintVisitor : IComponentVisitor {
    void visit(IComponent component) {
        writeln("Visiting: ", component.name());
    }
}

tree.accept(new PrintVisitor());
```

## See Also

- [examples/composite.d](../examples/composite.d) - Complete working examples
- [tests/patterns/composites.d](../../tests/patterns/composites.d) - Unit tests
