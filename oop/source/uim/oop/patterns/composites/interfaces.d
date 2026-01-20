/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.composites.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Component interface for the Composite pattern.
 * Declares common operations for both simple and complex objects.
 */
interface ICompositeComponent {
  /**
   * Execute the component's operation.
   * Returns: Result of the operation
   */
  string execute();

  /**
   * Get the component's name.
   * Returns: The name of the component
   */
  string name();

  /**
   * Check if this is a composite (has children).
   * Returns: true if composite, false if leaf
   */
  bool isComposite();
}

/**
 * Composite interface that can contain child components.
 */
interface IComposite : ICompositeComponent {
  /**
   * Add a child component.
   * Params:
   *   component = The component to add
   */
  void add(ICompositeComponent component);

  /**
   * Remove a child component.
   * Params:
   *   component = The component to remove
   */
  void remove(ICompositeComponent component);

  /**
   * Get a child component by index.
   * Params:
   *   index = The index of the child
   * Returns: The child component
   */
  ICompositeComponent getChild(size_t index);

  /**
   * Get all children.
   * Returns: Array of child components
   */
  ICompositeComponent[] children();

  /**
   * Get the number of children.
   * Returns: Child count
   */
  size_t childCount();

  /**
   * Clear all children.
   */
  void clear();
}

/**
 * Leaf component interface (has no children).
 */
interface ILeaf : ICompositeComponent {
  /**
   * Set the component's value.
   * Params:
   *   value = The value to set
   */
  void value(string value);

  /**
   * Get the component's value.
   * Returns: The value
   */
  string value();
}

/**
 * Visitor interface for traversing composite structures.
 */
interface IComponentVisitor {
  /**
   * Visit a component.
   * Params:
   *   component = The component to visit
   */
  void visit(ICompositeComponent component);
}

/**
 * Interface for components that can be traversed.
 */
interface ITraversable {
  /**
   * Accept a visitor for traversal.
   * Params:
   *   visitor = The visitor
   */
  void accept(IComponentVisitor visitor);

  /**
   * Traverse all components depth-first.
   * Params:
   *   callback = Function to call for each component
   */
  void traverse(void delegate(ICompositeComponent) @safe callback);
}
