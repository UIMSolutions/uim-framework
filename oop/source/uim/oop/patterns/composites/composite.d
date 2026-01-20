/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.composites.composite;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Base component abstract class.
 */
abstract class Component : ICompositeComponent, ITraversable {
  protected string _name;

  /**
   * Create a component with a name.
   * Params:
   *   name = The component name
   */
  this(string name) {
    _name = name;
  }

  /**
   * Get the component's name.
   * Returns: The name
   */
  string name() {
    return _name;
  }

  /**
   * Check if this is a composite.
   * Returns: false by default (override in Composite)
   */
  bool isComposite() {
    return false;
  }

  /**
   * Execute the component's operation.
   * Returns: Result of the operation
   */
  abstract string execute();

  /**
   * Accept a visitor for traversal.
   * Params:
   *   visitor = The visitor
   */
  void accept(IComponentVisitor visitor) {
    visitor.visit(this);
  }

  /**
   * Traverse (default implementation for leaf).
   * Params:
   *   callback = Function to call
   */
  void traverse(void delegate(ICompositeComponent) @safe callback) {
    callback(this);
  }
}

/**
 * Leaf component (no children).
 */
class Leaf : Component, ILeaf {
  protected string _value;

  /**
   * Create a leaf component.
   * Params:
   *   name = The component name
   *   value = The component value
   */
  this(string name, string value = "") {
    super(name);
    _value = value;
  }

  /**
   * Set the component's value.
   * Params:
   *   val = The value to set
   */
  void value(string val) {
    _value = val;
  }

  /**
   * Get the component's value.
   * Returns: The value
   */
  string value() {
    return _value;
  }

  /**
   * Execute the leaf operation.
   * Returns: The leaf's value
   */
  override string execute() {
    return _value;
  }
}

/**
 * Composite component (can contain children).
 */
class Composite : Component, IComposite {
  protected ICompositeComponent[] _children;

  /**
   * Create a composite component.
   * Params:
   *   name = The component name
   */
  this(string name) {
    super(name);
  }

  /**
   * Check if this is a composite.
   * Returns: true
   */
  override bool isComposite() {
    return true;
  }

  /**
   * Add a child component.
   * Params:
   *   component = The component to add
   */
  void add(ICompositeComponent component) {
    if (component !is null) {
      _children ~= component;
    }
  }

  /**
   * Remove a child component.
   * Params:
   *   component = The component to remove
   */
  void remove(ICompositeComponent component) {
    import std.algorithm : remove;
    import std.array : array;

    if (component !is null) {
      _children = _children.remove!(c => c is component).array;
    }
  }

  /**
   * Get a child component by index.
   * Params:
   *   index = The index of the child
   * Returns: The child component
   */
  ICompositeComponent getChild(size_t index) {
    if (index < _children.length) {
      return _children[index];
    }
    return null;
  }

  /**
   * Get all children.
   * Returns: Array of child components
   */
  ICompositeComponent[] children() {
    return _children.dup;
  }

  /**
   * Get the number of children.
   * Returns: Child count
   */
  size_t childCount() {
    return _children.length;
  }

  /**
   * Clear all children.
   */
  void clear() {
    _children.length = 0;
  }

  /**
   * Execute the composite operation (executes all children).
   * Returns: Combined result
   */
  override string execute() {
    string result = "";
    foreach (i, child; _children) {
      if (i > 0) result ~= ", ";
      result ~= child.execute();
    }
    return result;
  }

  /**
   * Traverse all components depth-first.
   * Params:
   *   callback = Function to call for each component
   */
  override void traverse(void delegate(ICompositeComponent) @safe callback) {
    callback(this);
    foreach (child; _children) {
      if (auto traversable = cast(ITraversable) child) {
        traversable.traverse(callback);
      } else {
        callback(child);
      }
    }
  }
}

/**
 * Tree component for hierarchical structures.
 */
class Tree : Composite {
  /**
   * Create a tree component.
   * Params:
   *   name = The tree name
   */
  this(string name) {
    super(name);
  }

  /**
   * Find a component by name.
   * Params:
   *   name = The name to search for
   * Returns: The component if found, null otherwise
   */
  ICompositeComponent find(string name) {
    ICompositeComponent result = null;
    traverse((component) {
      if (component.name() == name) {
        result = component;
      }
    });
    return result;
  }

  /**
   * Get the depth of the tree.
   * Returns: Maximum depth
   */
  size_t depth() {
    return calculateDepth(this);
  }

  private size_t calculateDepth(ICompositeComponent component) {
    if (!component.isComposite()) {
      return 1;
    }

    if (auto composite = cast(IComposite) component) {
      size_t maxDepth = 0;
      foreach (child; composite.children()) {
        size_t childDepth = calculateDepth(child);
        if (childDepth > maxDepth) {
          maxDepth = childDepth;
        }
      }
      return maxDepth + 1;
    }

    return 1;
  }

  /**
   * Count total nodes in the tree.
   * Returns: Node count
   */
  size_t nodeCount() {
    size_t count = 0;
    traverse((component) { count++; });
    return count;
  }
}

/**
 * Helper function to create a leaf.
 */
Leaf createLeaf(string name, string value = "") {
  return new Leaf(name, value);
}

/**
 * Helper function to create a composite.
 */
Composite createComposite(string name) {
  return new Composite(name);
}

/**
 * Helper function to create a tree.
 */
Tree createTree(string name) {
  return new Tree(name);
}

// Unit tests
unittest {
  auto leaf = createLeaf("Leaf1", "Value1");
  assert(leaf.name() == "Leaf1");
  assert(leaf.value() == "Value1");
  assert(leaf.execute() == "Value1");
  assert(!leaf.isComposite());
}

unittest {
  auto composite = createComposite("Parent");
  assert(composite.isComposite());
  assert(composite.childCount() == 0);

  composite.add(createLeaf("Child1", "A"));
  composite.add(createLeaf("Child2", "B"));
  assert(composite.childCount() == 2);

  auto result = composite.execute();
  assert(result == "A, B");
}

unittest {
  auto tree = createTree("Root");
  tree.add(createLeaf("Leaf1", "A"));
  
  auto branch = createComposite("Branch");
  branch.add(createLeaf("Leaf2", "B"));
  branch.add(createLeaf("Leaf3", "C"));
  tree.add(branch);

  assert(tree.childCount() == 2);
  assert(tree.nodeCount() == 5); // Root + 2 leaves + branch + 2 leaves in branch
  assert(tree.depth() == 3);
}

unittest {
  auto composite = createComposite("Parent");
  auto child1 = createLeaf("Child1", "A");
  auto child2 = createLeaf("Child2", "B");

  composite.add(child1);
  composite.add(child2);
  assert(composite.childCount() == 2);

  composite.remove(child1);
  assert(composite.childCount() == 1);
  assert(composite.execute() == "B");

  composite.clear();
  assert(composite.childCount() == 0);
}

unittest {
  auto tree = createTree("Root");
  tree.add(createLeaf("Item1", "Value1"));
  
  auto branch = createComposite("Branch");
  branch.add(createLeaf("Item2", "Value2"));
  tree.add(branch);

  auto found = tree.find("Item2");
  assert(found !is null);
  assert(found.name() == "Item2");

  auto notFound = tree.find("NonExistent");
  assert(notFound is null);
}

unittest {
  auto composite = createComposite("Test");
  int count = 0;
  
  composite.add(createLeaf("A", "1"));
  composite.add(createLeaf("B", "2"));
  composite.add(createLeaf("C", "3"));

  composite.traverse((component) {
    count++;
  });

  assert(count == 4); // Composite + 3 leaves
}
