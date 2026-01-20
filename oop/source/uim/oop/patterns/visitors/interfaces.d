/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.visitors.interfaces;

/**
 * Visitor interface that declares visit operations for each concrete element type.
 * The visitor pattern allows adding new operations to existing object structures
 * without modifying those structures.
 */
interface IVisitor {
    /**
     * Generic visit method for elements.
     * Params:
     *   element = The element to visit
     */
    @safe void visit(IElement element);
}

/**
 * Element interface that declares an accept method.
 * This method accepts a visitor and calls the appropriate visit method.
 */
interface IElement {
    /**
     * Accepts a visitor.
     * Params:
     *   visitor = The visitor to accept
     */
    @safe void accept(IVisitor visitor);
    
    /**
     * Gets the element name.
     * Returns: The element identifier
     */
    @safe string name() const;
}

/**
 * Generic visitor interface with typed visit methods.
 * Provides compile-time type safety for visitor operations.
 */
interface IGenericVisitor(TElement) {
    /**
     * Visits a typed element.
     * Params:
     *   element = The element to visit
     */
    @safe void visit(TElement element);
}

/**
 * Object structure interface that holds a collection of elements.
 * Provides methods to iterate over elements and accept visitors.
 */
interface IObjectStructure {
    /**
     * Adds an element to the structure.
     * Params:
     *   element = The element to add
     */
    @safe void addElement(IElement element);
    
    /**
     * Removes an element from the structure.
     * Params:
     *   element = The element to remove
     */
    @safe void removeElement(IElement element);
    
    /**
     * Accepts a visitor for all elements.
     * Params:
     *   visitor = The visitor to apply to all elements
     */
    @safe void accept(IVisitor visitor);
    
    /**
     * Gets the number of elements.
     * Returns: The element count
     */
    @safe size_t elementCount() const;
}

/**
 * Visitable interface for objects that can be visited.
 * Combines element functionality with additional capabilities.
 */
interface IVisitable : IElement {
    /**
     * Gets the element type.
     * Returns: The type identifier
     */
    @safe string elementType() const;
}

/**
 * Accumulating visitor interface that collects results.
 * Useful for visitors that need to aggregate information.
 */
interface IAccumulatingVisitor(TResult) : IVisitor {
    /**
     * Gets the accumulated result.
     * Returns: The visitor's result
     */
    @safe TResult result() const;
    
    /**
     * Resets the visitor's state.
     */
    @safe void reset();
}

/**
 * Hierarchical element interface for composite structures.
 * Elements can have children that also accept visitors.
 */
interface IHierarchicalElement : IElement {
    /**
     * Gets child elements.
     * Returns: Array of child elements
     */
    @safe IHierarchicalElement[] children() const;
    
    /**
     * Adds a child element.
     * Params:
     *   child = The child element to add
     */
    @safe void addChild(IHierarchicalElement child);
}
