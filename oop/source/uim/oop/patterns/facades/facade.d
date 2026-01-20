/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.facades.facade;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Abstract base facade class.
 */
abstract class Facade : IFacade {
  protected bool _initialized;

  /**
   * Check if the facade is ready for operations.
   * Returns: true if ready
   */
  bool isReady() {
    return _initialized;
  }

  /**
   * Initialize the facade and its subsystems.
   * Returns: true if initialization successful
   */
  abstract bool initialize();

  /**
   * Shutdown the facade and cleanup resources.
   */
  abstract void shutdown();
}

/**
 * Generic subsystem component base class.
 */
abstract class SubsystemComponent : ISubsystemComponent {
  protected string _name;
  protected bool _initialized;

  /**
   * Create a subsystem component.
   * Params:
   *   name = Component name
   */
  this(string name) {
    _name = name;
    _initialized = false;
  }

  /**
   * Get component name.
   * Returns: The name of the component
   */
  string name() {
    return _name;
  }

  /**
   * Initialize the component.
   * Returns: true if initialization successful
   */
  abstract bool initialize();

  /**
   * Shutdown the component.
   */
  abstract void shutdown();
}


/**
 * Simple facade wrapper for delegate-based operations.
 */
class SimpleFacade : Facade {
  private bool delegate() @safe _initFunc;
  private void delegate() @safe _shutdownFunc;

  /**
   * Create a simple facade.
   * Params:
   *   initFunc = Initialization function
   *   shutdownFunc = Shutdown function
   */
  this(bool delegate() @safe initFunc, void delegate() @safe shutdownFunc) {
    _initFunc = initFunc;
    _shutdownFunc = shutdownFunc;
  }

  /**
   * Initialize using the provided function.
   * Returns: Result of initialization function
   */
  override bool initialize() {
    if (_initialized) {
      return true;
    }

    if (_initFunc) {
      _initialized = _initFunc();
      return _initialized;
    }
    return false;
  }

  /**
   * Shutdown using the provided function.
   */
  override void shutdown() {
    if (_shutdownFunc) {
      _shutdownFunc();
    }
    _initialized = false;
  }
}

/**
 * Helper function to create a simple facade.
 */
SimpleFacade createSimpleFacade(
  bool delegate() @safe initFunc,
  void delegate() @safe shutdownFunc) {
  return new SimpleFacade(initFunc, shutdownFunc);
}

// Unit tests
unittest {
  class TestComponent : SubsystemComponent {
    this(string name) {
      super(name);
    }

    override bool initialize() {
      _initialized = true;
      return true;
    }

    override void shutdown() {
      _initialized = false;
    }
  }

  auto facade = new CompositeFacade();
  facade.addComponent(new TestComponent("Component1"));
  facade.addComponent(new TestComponent("Component2"));

  assert(!facade.isReady(), "Should not be ready before initialization");
  assert(facade.initialize(), "Initialization should succeed");
  assert(facade.isReady(), "Should be ready after initialization");

  auto components = facade.components();
  assert(components.length == 2, "Should have 2 components");
  assert(facade.isComponentActive("Component1"), "Component1 should be active");
  assert(facade.isComponentActive("Component2"), "Component2 should be active");

  facade.shutdown();
  assert(!facade.isReady(), "Should not be ready after shutdown");
  assert(!facade.isComponentActive("Component1"), "Component1 should be inactive");
}

unittest {
  auto facade = new ConfigurableFacade();

  string[string] config;
  config["host"] = "localhost";
  config["port"] = "8080";

  facade.configure(config);

  assert(facade.getConfig("host") == "localhost", "Should get configured value");
  assert(facade.getConfig("port") == "8080", "Should get configured value");
  assert(facade.getConfig("unknown", "default") == "default", "Should return default for unknown key");
}

unittest {
  bool initialized = false;
  bool shutdownCalled = false;

  auto facade = createSimpleFacade(
    () { initialized = true; return true; },
    () { shutdownCalled = true; }
  );

  assert(!facade.isReady(), "Should not be ready initially");
  assert(facade.initialize(), "Should initialize");
  assert(initialized, "Init function should be called");
  assert(facade.isReady(), "Should be ready after init");

  facade.shutdown();
  assert(shutdownCalled, "Shutdown function should be called");
  assert(!facade.isReady(), "Should not be ready after shutdown");
}
