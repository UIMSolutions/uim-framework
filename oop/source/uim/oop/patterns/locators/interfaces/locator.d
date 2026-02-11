module uim.oop.patterns.locators.interfaces.locator;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for Service Locator pattern.
 * Provides centralized registry for obtaining services.
 */
interface IServiceLocator {
  /**
   * Register a service with the locator.
   * Params:
   *   name = The name to register the service under
   *   service = The service instance to register
   */
  void registerService(string name, IService service) @safe;

  /**
   * Get a service by name.
   * Params:
   *   name = The name of the service to retrieve
   * Returns: The service instance, or null if not found
   */
  IService getService(string name) @safe;

  /**
   * Check if a service is registered.
   * Params:
   *   name = The name of the service to check
   * Returns: true if the service is registered, false otherwise
   */
  bool hasService(string name) @safe;

  /**
   * Unregister a service.
   * Params:
   *   name = The name of the service to unregister
   * Returns: true if the service was unregistered, false if it wasn't found
   */
  bool unregisterService(string name) @safe;

  /**
   * Get all registered service names.
   * Returns: Array of service names
   */
  string[] getServiceNames() @safe;

  /**
   * Clear all registered services.
   */
  void clear() @safe;
}