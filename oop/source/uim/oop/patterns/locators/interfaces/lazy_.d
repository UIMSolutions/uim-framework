module uim.oop.patterns.locators.interfaces.lazy_;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for lazy-loading service locator.
 */
interface ILazyServiceLocator : IServiceLocator {
  /**
   * Register a service factory for lazy instantiation.
   * Params:
   *   name = The name to register the service under
   *   factory = Factory function that creates the service
   */
  void registerFactory(string name, IService delegate() @safe factory) @safe;
}