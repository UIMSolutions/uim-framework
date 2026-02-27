module uim.oop.patterns.locators.interfaces.lazy_;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for lazy-loading object locator.
 */
interface ILazyLocatorObject : ILocator {
  /**
   * Register a object factory for lazy instantiation.
   * Params:
   *   name = The name to register the object under
   *   factory = Factory function that creates the object
   */
  void registerFactory(string name, ILocatorObject delegate() @safe factory) @safe;
}