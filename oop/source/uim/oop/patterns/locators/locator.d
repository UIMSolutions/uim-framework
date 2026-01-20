/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.locators.locator;

import uim.oop.patterns.locators.interfaces;

/**
 * Base abstract service that can be registered with Service Locator.
 */
abstract class Service : IService {
  private string _name;

  /**
   * Constructor.
   * Params:
   *   name = The name of the service
   */
  this(string name) @safe {
    _name = name;
  }

  /**
   * Get the name of this service.
   */
  string serviceName() @safe {
    return _name;
  }

  /**
   * Execute the service's main operation.
   * Override in derived classes.
   */
  abstract string execute() @safe;
}

/**
 * Basic Service Locator implementation.
 * Provides centralized registry for obtaining services.
 */
class ServiceLocator : IServiceLocator {
  private IService[string] _services;

  /**
   * Constructor.
   */
  this() @safe {
    _services = null;
  }

  /**
   * Register a service with the locator.
   */
  void registerService(string name, IService service) @safe {
    _services[name] = service;
  }

  /**
   * Get a service by name.
   */
  IService getService(string name) @safe {
    return name in _services ? _services[name] : null;
  }

  /**
   * Check if a service is registered.
   */
  bool hasService(string name) @safe {
    return (name in _services) !is null;
  }

  /**
   * Unregister a service.
   */
  bool unregisterService(string name) @safe {
    if (name in _services) {
      _services.remove(name);
      return true;
    }
    return false;
  }

  /**
   * Get all registered service names.
   */
  string[] getServiceNames() @safe {
    import std.array : array;
    return _services.keys.array;
  }

  /**
   * Clear all registered services.
   */
  void clear() @safe {
    _services.clear();
  }
}

/**
 * Lazy-loading Service Locator.
 * Creates services on-demand using factory functions.
 */
class LazyServiceLocator : ILazyServiceLocator {
  private IService[string] _services;
  private IService delegate() @safe[string] _factories;

  /**
   * Constructor.
   */
  this() @safe {
    _services = null;
    _factories = null;
  }

  /**
   * Register a service with the locator.
   */
  void registerService(string name, IService service) @safe {
    _services[name] = service;
  }

  /**
   * Register a service factory for lazy instantiation.
   */
  void registerFactory(string name, IService delegate() @safe factory) @safe {
    _factories[name] = factory;
  }

  /**
   * Get a service by name.
   * If service not instantiated, creates it using factory.
   */
  IService getService(string name) @safe {
    // Check if already instantiated
    if (name in _services) {
      return _services[name];
    }

    // Check if factory exists
    if (name in _factories) {
      auto service = _factories[name]();
      _services[name] = service;
      return service;
    }

    return null;
  }

  /**
   * Check if a service is registered.
   */
  bool hasService(string name) @safe {
    return (name in _services) !is null || (name in _factories) !is null;
  }

  /**
   * Unregister a service.
   */
  bool unregisterService(string name) @safe {
    bool removed = false;
    if (name in _services) {
      _services.remove(name);
      removed = true;
    }
    if (name in _factories) {
      _factories.remove(name);
      removed = true;
    }
    return removed;
  }

  /**
   * Get all registered service names.
   */
  string[] getServiceNames() @safe {
    import std.array : array;
    import std.algorithm : uniq, sort;
    
    auto keys = _services.keys ~ _factories.keys;
    return keys.sort.uniq.array;
  }

  /**
   * Clear all registered services and factories.
   */
  void clear() @safe {
    _services.clear();
    _factories.clear();
  }
}

/**
 * Cached Service Locator.
 * Caches service lookups for improved performance.
 */
class CachedServiceLocator : ICachedServiceLocator {
  private IService[string] _services;
  private IService[string] _cache;
  private bool _cacheEnabled;

  /**
   * Constructor.
   */
  this() @safe {
    _services = null;
    _cache = null;
    _cacheEnabled = true;
  }

  /**
   * Register a service with the locator.
   */
  void registerService(string name, IService service) @safe {
    _services[name] = service;
    if (_cacheEnabled) {
      _cache[name] = service;
    }
  }

  /**
   * Get a service by name.
   */
  IService getService(string name) @safe {
    // Check cache first if enabled
    if (_cacheEnabled && name in _cache) {
      return _cache[name];
    }

    // Get from services
    auto service = name in _services ? _services[name] : null;
    
    // Cache it if found and caching is enabled
    if (_cacheEnabled && service !is null) {
      _cache[name] = service;
    }

    return service;
  }

  /**
   * Check if a service is registered.
   */
  bool hasService(string name) @safe {
    return (name in _services) !is null;
  }

  /**
   * Unregister a service.
   */
  bool unregisterService(string name) @safe {
    bool removed = false;
    if (name in _services) {
      _services.remove(name);
      removed = true;
    }
    if (name in _cache) {
      _cache.remove(name);
    }
    return removed;
  }

  /**
   * Get all registered service names.
   */
  string[] getServiceNames() @safe {
    import std.array : array;
    return _services.keys.array;
  }

  /**
   * Clear all registered services.
   */
  void clear() @safe {
    _services.clear();
    _cache.clear();
  }

  /**
   * Enable or disable caching.
   */
  void setCacheEnabled(bool enabled) @safe {
    _cacheEnabled = enabled;
    if (!enabled) {
      _cache.clear();
    }
  }

  /**
   * Check if caching is enabled.
   */
  bool isCacheEnabled() @safe {
    return _cacheEnabled;
  }

  /**
   * Clear the service cache.
   */
  void clearCache() @safe {
    _cache.clear();
  }
}

/**
 * Hierarchical Service Locator.
 * Supports parent-child relationship for service lookup.
 */
class HierarchicalServiceLocator : IServiceLocator {
  private IService[string] _services;
  private HierarchicalServiceLocator _parent;

  /**
   * Constructor.
   */
  this(HierarchicalServiceLocator parent = null) @safe {
    _services = null;
    _parent = parent;
  }

  /**
   * Set the parent locator.
   */
  void setParent(HierarchicalServiceLocator parent) @safe {
    _parent = parent;
  }

  /**
   * Get the parent locator.
   */
  HierarchicalServiceLocator getParent() @safe {
    return _parent;
  }

  /**
   * Register a service with the locator.
   */
  void registerService(string name, IService service) @safe {
    _services[name] = service;
  }

  /**
   * Get a service by name.
   * Searches parent locators if not found locally.
   */
  IService getService(string name) @safe {
    // Check local services first
    if (name in _services) {
      return _services[name];
    }

    // Search parent if available
    if (_parent !is null) {
      return _parent.getService(name);
    }

    return null;
  }

  /**
   * Check if a service is registered locally or in parent.
   */
  bool hasService(string name) @safe {
    if (name in _services) {
      return true;
    }
    if (_parent !is null) {
      return _parent.hasService(name);
    }
    return false;
  }

  /**
   * Unregister a service (only from local registry).
   */
  bool unregisterService(string name) @safe {
    if (name in _services) {
      _services.remove(name);
      return true;
    }
    return false;
  }

  /**
   * Get all registered service names (local only).
   */
  string[] getServiceNames() @safe {
    import std.array : array;
    return _services.keys.array;
  }

  /**
   * Clear all registered services (local only).
   */
  void clear() @safe {
    _services.clear();
  }
}

// Unit Tests

@safe unittest {
  // Create a simple test service
  class TestService : Service {
    this() {
      super("TestService");
    }

    override string execute() {
      return "Test service executed";
    }
  }

  // Test basic ServiceLocator
  auto locator = new ServiceLocator();
  auto service = new TestService();
  
  locator.registerService("test", service);
  assert(locator.hasService("test"));
  
  auto retrieved = locator.getService("test");
  assert(retrieved !is null);
  assert(retrieved.serviceName() == "TestService");
  
  assert(locator.unregisterService("test"));
  assert(!locator.hasService("test"));
}

@safe unittest {
  // Test LazyServiceLocator
  class LazyTestService : Service {
    this() {
      super("LazyService");
    }

    override string execute() {
      return "Lazy service executed";
    }
  }

  auto locator = new LazyServiceLocator();
  
  // Register factory
  locator.registerFactory("lazy", () => cast(IService) new LazyTestService());
  assert(locator.hasService("lazy"));
  
  // Service should be created on first access
  auto service = locator.getService("lazy");
  assert(service !is null);
  assert(service.serviceName() == "LazyService");
  
  // Second access should return same instance
  auto service2 = locator.getService("lazy");
  assert(service is service2);
}

@safe unittest {
  // Test CachedServiceLocator
  class CachedTestService : Service {
    this() {
      super("CachedService");
    }

    override string execute() {
      return "Cached service executed";
    }
  }

  auto locator = new CachedServiceLocator();
  assert(locator.isCacheEnabled());
  
  auto service = new CachedTestService();
  locator.registerService("cached", service);
  
  auto retrieved = locator.getService("cached");
  assert(retrieved !is null);
  
  locator.clearCache();
  retrieved = locator.getService("cached");
  assert(retrieved !is null);
  
  locator.setCacheEnabled(false);
  assert(!locator.isCacheEnabled());
}

@safe unittest {
  // Test HierarchicalServiceLocator
  class ParentService : Service {
    this() {
      super("ParentService");
    }

    override string execute() {
      return "Parent service executed";
    }
  }

  class ChildService : Service {
    this() {
      super("ChildService");
    }

    override string execute() {
      return "Child service executed";
    }
  }

  auto parentLocator = new HierarchicalServiceLocator();
  auto childLocator = new HierarchicalServiceLocator(parentLocator);
  
  parentLocator.registerService("parent", new ParentService());
  childLocator.registerService("child", new ChildService());
  
  // Child should find its own service
  assert(childLocator.hasService("child"));
  auto childSvc = childLocator.getService("child");
  assert(childSvc !is null);
  
  // Child should find parent's service
  assert(childLocator.hasService("parent"));
  auto parentSvc = childLocator.getService("parent");
  assert(parentSvc !is null);
  assert(parentSvc.serviceName() == "ParentService");
}
