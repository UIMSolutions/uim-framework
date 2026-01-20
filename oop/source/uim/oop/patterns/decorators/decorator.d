/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.decorators.decorator;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Abstract base decorator class.
 */
abstract class Decorator : IDecorator {
  protected IDecoratorComponent _component;

  /**
   * Create a decorator wrapping a component.
   * Params:
   *   component = The component to decorate
   */
  this(IDecoratorComponent component) {
    _component = component;
  }

  /**
   * Get the wrapped component.
   * Returns: The component being decorated
   */
  IDecoratorComponent component() {
    return _component;
  }

  /**
   * Set the wrapped component.
   * Params:
   *   comp = The component to wrap
   */
  void component(IDecoratorComponent comp) {
    _component = comp;
  }

  /**
   * Execute the component's operation.
   * Default implementation delegates to the wrapped component.
   * Returns: Result of the operation
   */
  string execute() {
    return _component ? _component.execute() : "";
  }
}

/**
 * Generic decorator for type-safe decoration.
 */
class GenericDecorator(T) : IGenericDecorator!T {
  protected T _wrappedObject;
  protected string delegate(T) @safe _executeDelegate;

  /**
   * Create a generic decorator.
   * Params:
   *   obj = The object to wrap
   *   executeFunc = Optional function to execute
   */
  this(T obj, string delegate(T) @safe executeFunc = null) {
    _wrappedObject = obj;
    _executeDelegate = executeFunc;
  }

  /**
   * Get the wrapped object.
   * Returns: The object being decorated
   */
  T wrappedObject() {
    return _wrappedObject;
  }

  /**
   * Set the wrapped object.
   * Params:
   *   obj = The object to wrap
   */
  void wrappedObject(T obj) {
    _wrappedObject = obj;
  }

  /**
   * Execute the decorator's operation.
   * Returns: Result of the operation
   */
  string execute() {
    if (_executeDelegate) {
      return _executeDelegate(_wrappedObject);
    }
    return "";
  }
}





/**
 * Helper function to create a generic decorator.
 */
GenericDecorator!T createGenericDecorator(T)(
    T obj,
    string delegate(T) @safe executeFunc = null) {
  return new GenericDecorator!T(obj, executeFunc);
}

// Unit tests
unittest {
  class SimpleComponent : IDecoratorComponent {
    @safe string execute() {
      return "Simple";
    }
  }

  class UppercaseDecorator : Decorator {
    this(IDecoratorComponent component) {
      super(component);
    }

    override @safe string execute() {
      import std.string : toUpper;
      return super.execute().toUpper();
    }
  }

  auto component = new SimpleComponent();
  auto decorated = new UppercaseDecorator(component);
  
  assert(component.execute() == "Simple");
  assert(decorated.execute() == "SIMPLE");
}

unittest {
  class NumberComponent : IDecoratorComponent {
    private int _value;
    
    this(int value) { _value = value; }
    
    @safe string execute() {
      import std.conv : to;
      return _value.to!string;
    }
  }

  class PrefixDecorator : Decorator {
    private string _prefix;
    
    this(IDecoratorComponent component, string prefix) {
      super(component);
      _prefix = prefix;
    }
    
    override @safe string execute() {
      return _prefix ~ super.execute();
    }
  }

  auto component = new NumberComponent(42);
  auto decorated = new PrefixDecorator(component, "Value: ");
  
  assert(decorated.execute() == "Value: 42");
}

unittest {
  class TestComponent : IDecoratorComponent {
    @safe string execute() {
      return "Core";
    }
  }

  string beforeResult = "";
  string afterResult = "";

  auto decorator = createFunctionalDecorator(
    new TestComponent(),
    () { beforeResult = "Before"; return "["; },
    () { afterResult = "After"; return "]"; }
  );

  auto result = decorator.execute();
  assert(result == "[Core]");
  assert(beforeResult == "Before");
  assert(afterResult == "After");
}

unittest {
  class DataObject {
    int value;
    this(int v) { value = v; }
  }

  auto obj = new DataObject(100);
  auto decorator = createGenericDecorator(obj, (DataObject o) {
    import std.conv : to;
    return "Value is: " ~ o.value.to!string;
  });

  assert(decorator.execute() == "Value is: 100");
  assert(decorator.wrappedObject() is obj);
}
