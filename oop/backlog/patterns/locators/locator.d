/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.locators.locator;

import uim.oop.patterns.locators.interfaces;
@safe:
/**
 * Base abstract object that can be registered with Object Locator.
 */
abstract class LocatorObject : ILocatorObject {
  private string _name;

  /**
   * Constructor.
   * Params:
   *   name = The name of the object
   */
  this(string name) {
    _name = name;
  }

  /**
   * Get the name of this object.
   */
  string objectName() {
    return _name;
  }

  /**
   * Execute the object's main operation.
   * Override in derived classes.
   */
  abstract string execute() @safe;
}

/**
 * Basic Object Locator implementation.
 * Provides centralized registry for obtaining objects.
 */
class ObjectLocator : ILocator {
  private ILocatorObject[string] _objects;

  /**
   * Constructor.
   */
  this() {
    _objects = null;
  }

  /**
   * Register a object with the locator.
   */
  void registerObject(string name, ILocatorObject object) {
    _objects[name] = object;
  }

  /**
   * Get a object by name.
   */
  ILocatorObject getObject(string name) {
    return name in _objects ? _objects[name] : null;
  }

  /**
   * Check if a object is registered.
   */
  bool hasObject(string name) {
    return (name in _objects) !is null;
  }

  /**
   * Unregister a object.
   */
  bool unregisterObject(string name) {
    if (name in _objects) {
      _objects.remove(name);
      return true;
    }
    return false;
  }

  /**
   * Get all registered object names.
   */
  string[] getObjectNames() {
    import std.array : array;
    return _objects.keys.array;
  }

  /**
   * Clear all registered objects.
   */
  void clear() {
    _objects.clear();
  }
}

/**
 * Lazy-loading Object Locator.
 * Creates objects on-demand using factory functions.
 */
class LazyObjectLocator : ILazyLocatorObject {
  private ILocatorObject[string] _objects;
  private ILocatorObject delegate() @safe[string] _factories;

  /**
   * Constructor.
   */
  this() {
    _objects = null;
    _factories = null;
  }

  /**
   * Register a object with the locator.
   */
  void registerObject(string name, ILocatorObject object) {
    _objects[name] = object;
  }

  /**
   * Register a object factory for lazy instantiation.
   */
  void registerFactory(string name, ILocatorObject delegate() @safe factory) {
    _factories[name] = factory;
  }

  /**
   * Get a object by name.
   * If object not instantiated, creates it using factory.
   */
  ILocatorObject getObject(string name) {
    // Check if already instantiated
    if (name in _objects) {
      return _objects[name];
    }

    // Check if factory exists
    if (name in _factories) {
      auto object = _factories[name]();
      _objects[name] = object;
      return object;
    }

    return null;
  }

  /**
   * Check if a object is registered.
   */
  bool hasObject(string name) {
    return (name in _objects) !is null || (name in _factories) !is null;
  }

  /**
   * Unregister a object.
   */
  bool unregisterObject(string name) {
    bool removed = false;
    if (name in _objects) {
      _objects.remove(name);
      removed = true;
    }
    if (name in _factories) {
      _factories.remove(name);
      removed = true;
    }
    return removed;
  }

  /**
   * Get all registered object names.
   */
  string[] getObjectNames() {
    import std.array : array;
    import std.algorithm : uniq, sort;
    
    auto keys = _objects.keys ~ _factories.keys;
    return keys.sort.uniq.array;
  }

  /**
   * Clear all registered objects and factories.
   */
  void clear() {
    _objects.clear();
    _factories.clear();
  }
}

/**
 * Cached Object Locator.
 * Caches object lookups for improved performance.
 */
class CachedObjectLocator : ICachedObjectLocator {
  private ILocatorObject[string] _objects;
  private ILocatorObject[string] _cache;
  private bool _cacheEnabled;

  /**
   * Constructor.
   */
  this() {
    _objects = null;
    _cache = null;
    _cacheEnabled = true;
  }

  /**
   * Register a object with the locator.
   */
  void registerObject(string name, ILocatorObject object) {
    _objects[name] = object;
    if (_cacheEnabled) {
      _cache[name] = object;
    }
  }

  /**
   * Get a object by name.
   */
  ILocatorObject getObject(string name) {
    // Check cache first if enabled
    if (_cacheEnabled && name in _cache) {
      return _cache[name];
    }

    // Get from objects
    auto object = name in _objects ? _objects[name] : null;
    
    // Cache it if found and caching is enabled
    if (_cacheEnabled && object !is null) {
      _cache[name] = object;
    }

    return object;
  }

  /**
   * Check if a object is registered.
   */
  bool hasObject(string name) {
    return (name in _objects) !is null;
  }

  /**
   * Unregister a object.
   */
  bool unregisterObject(string name) {
    bool removed = false;
    if (name in _objects) {
      _objects.remove(name);
      removed = true;
    }
    if (name in _cache) {
      _cache.remove(name);
    }
    return removed;
  }

  /**
   * Get all registered object names.
   */
  string[] getObjectNames() {
    import std.array : array;
    return _objects.keys.array;
  }

  /**
   * Clear all registered objects.
   */
  void clear() {
    _objects.clear();
    _cache.clear();
  }

  /**
   * Enable or disable caching.
   */
  void setCacheEnabled(bool enabled) {
    _cacheEnabled = enabled;
    if (!enabled) {
      _cache.clear();
    }
  }

  /**
   * Check if caching is enabled.
   */
  bool isCacheEnabled() {
    return _cacheEnabled;
  }

  /**
   * Clear the object cache.
   */
  void clearCache() {
    _cache.clear();
  }
}

/**
 * Hierarchical Object Locator.
 * Supports parent-child relationship for object lookup.
 */
class HierarchicalObjectLocator : ILocator {
  private ILocatorObject[string] _objects;
  private HierarchicalObjectLocator _parent;

  /**
   * Constructor.
   */
  this(HierarchicalObjectLocator parent = null) {
    _objects = null;
    _parent = parent;
  }

  /**
   * Set the parent locator.
   */
  void setParent(HierarchicalObjectLocator parent) {
    _parent = parent;
  }

  /**
   * Get the parent locator.
   */
  HierarchicalObjectLocator getParent() {
    return _parent;
  }

  /**
   * Register a object with the locator.
   */
  void registerObject(string name, ILocatorObject object) {
    _objects[name] = object;
  }

  /**
   * Get a object by name.
   * Searches parent locators if not found locally.
   */
  ILocatorObject getObject(string name) {
    // Check local objects first
    if (name in _objects) {
      return _objects[name];
    }

    // Search parent if available
    if (_parent !is null) {
      return _parent.getObject(name);
    }

    return null;
  }

  /**
   * Check if a object is registered locally or in parent.
   */
  bool hasObject(string name) {
    if (name in _objects) {
      return true;
    }

    return _parent !is null ? _parent.hasObject(name) : false;
  }

  /**
   * Unregister a object (only from local registry).
   */
  bool unregisterObject(string name) {
    if (name in _objects) {
      _objects.remove(name);
      return true;
    }
    return false;
  }

  /**
   * Get all registered object names (local only).
   */
  string[] getObjectNames() {
    import std.array : array;
    return _objects.keys.array;
  }

  /**
   * Clear all registered objects (local only).
   */
  void clear() {
    _objects.clear();
  }
}

// Unit Tests

@safe unittest {
  // Create a simple test object
  class TestObject : LocatorObject {
    this() {
      super("TestObject");
    }

    override string execute() {
      return "Test object executed";
    }
  }

  // Test basic ObjectLocator
  auto locator = new ObjectLocator();
  auto object = new TestObject();
  
  locator.registerObject("test", object);
  assert(locator.hasObject("test"));
  
  auto retrieved = locator.getObject("test");
  assert(retrieved !is null);
  assert(retrieved.objectName() == "TestObject");
  
  assert(locator.unregisterObject("test"));
  assert(!locator.hasObject("test"));
}

@safe unittest {
  // Test LazyObjectLocator
  class LazyTestObject : LocatorObject {
    this() {
      super("LazyObject");
    }

    override string execute() {
      return "Lazy object executed";
    }
  }

  auto locator = new LazyObjectLocator();
  
  // Register factory
  locator.registerFactory("lazy", () => cast(ILocatorObject) new LazyTestObject());
  assert(locator.hasObject("lazy"));
  
  // Object should be created on first access
  auto object = locator.getObject("lazy");
  assert(object !is null);
  assert(object.objectName() == "LazyObject");
  
  // Second access should return same instance
  auto object2 = locator.getObject("lazy");
  assert(object is object2);
}

@safe unittest {
  // Test CachedObjectLocator
  class CachedTestObject : LocatorObject {
    this() {
      super("CachedObject");
    }

    override string execute() {
      return "Cached object executed";
    }
  }

  auto locator = new CachedObjectLocator();
  assert(locator.isCacheEnabled());
  
  auto object = new CachedTestObject();
  locator.registerObject("cached", object);
  
  auto retrieved = locator.getObject("cached");
  assert(retrieved !is null);
  
  locator.clearCache();
  retrieved = locator.getObject("cached");
  assert(retrieved !is null);
  
  locator.setCacheEnabled(false);
  assert(!locator.isCacheEnabled());
}

@safe unittest {
  // Test HierarchicalObjectLocator
  class ParentObject : LocatorObject {
    this() {
      super("ParentObject");
    }

    override string execute() {
      return "Parent object executed";
    }
  }

  class ChildObject : LocatorObject {
    this() {
      super("ChildObject");
    }

    override string execute() {
      return "Child object executed";
    }
  }

  auto parentLocator = new HierarchicalObjectLocator();
  auto childLocator = new HierarchicalObjectLocator(parentLocator);
  
  parentLocator.registerObject("parent", new ParentObject());
  childLocator.registerObject("child", new ChildObject());
  
  // Child should find its own object
  assert(childLocator.hasObject("child"));
  auto childSvc = childLocator.getObject("child");
  assert(childSvc !is null);
  
  // Child should find parent's object
  assert(childLocator.hasObject("parent"));
  auto parentSvc = childLocator.getObject("parent");
  assert(parentSvc !is null);
  assert(parentSvc.objectName() == "ParentObject");
}
