module uim.oop.patterns.decorators.generic;

import uim.oop;

mixin(ShowModule!());

@safe:

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
