module uim.oop.patterns.decorators.interfaces.general;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic decorator interface for type-safe decoration.
 */
interface IGenericDecorator(T) {
  /**
   * Get the wrapped object.
   * Returns: The object being decorated
   */
  T wrappedObject();

  /**
   * Set the wrapped object.
   * Params:
   *   obj = The object to wrap
   */
  void wrappedObject(T obj);
}