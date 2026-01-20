/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.locators.interfaces;

/**
 * Base interface for all services that can be registered with a Service Locator.
 */
interface IService {
  /**
   * Get the name of this service.
   */
  string serviceName() @safe;

  /**
   * Execute the service's main operation.
   */
  string execute() @safe;
}

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

/**
 * Interface for cached service locator.
 */
interface ICachedServiceLocator : IServiceLocator {
  /**
   * Enable or disable caching.
   * Params:
   *   enabled = true to enable caching, false to disable
   */
  void setCacheEnabled(bool enabled) @safe;

  /**
   * Check if caching is enabled.
   * Returns: true if caching is enabled, false otherwise
   */
  bool isCacheEnabled() @safe;

  /**
   * Clear the service cache.
   */
  void clearCache() @safe;
}
