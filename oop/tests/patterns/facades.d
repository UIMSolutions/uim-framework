/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.facades;

import uim.oop;
import std.stdio;

@safe:

// Test basic facade pattern
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

  auto component = new TestComponent("Test");
  assert(component.name() == "Test", "Component name should match");
  assert(component.initialize(), "Component should initialize");
  component.shutdown();
}

// Test composite facade
unittest {
  class DummyComponent : SubsystemComponent {
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
  assert(!facade.isReady(), "Facade should not be ready initially");

  facade.addComponent(new DummyComponent("Component1"));
  facade.addComponent(new DummyComponent("Component2"));
  facade.addComponent(new DummyComponent("Component3"));

  assert(facade.initialize(), "Facade initialization should succeed");
  assert(facade.isReady(), "Facade should be ready after initialization");

  auto components = facade.components();
  assert(components.length == 3, "Should have 3 components");
  assert(facade.isComponentActive("Component1"), "Component1 should be active");
  assert(facade.isComponentActive("Component2"), "Component2 should be active");
  assert(facade.isComponentActive("Component3"), "Component3 should be active");

  facade.shutdown();
  assert(!facade.isReady(), "Facade should not be ready after shutdown");
}

// Test facade with failing component
unittest {
  class SuccessComponent : SubsystemComponent {
    this() { super("Success"); }
    override bool initialize() { return true; }
    override void shutdown() {}
  }

  class FailingComponent : SubsystemComponent {
    this() { super("Failing"); }
    override bool initialize() { return false; }
    override void shutdown() {}
  }

  auto facade = new CompositeFacade();
  facade.addComponent(new SuccessComponent());
  facade.addComponent(new FailingComponent());

  assert(!facade.initialize(), "Facade initialization should fail");
  assert(!facade.isReady(), "Facade should not be ready after failed initialization");
}

// Test configurable facade
unittest {
  auto facade = new ConfigurableFacade();

  string[string] config;
  config["database"] = "postgres";
  config["host"] = "localhost";
  config["port"] = "5432";

  facade.configure(config);

  assert(facade.getConfig("database") == "postgres", "Should get database config");
  assert(facade.getConfig("host") == "localhost", "Should get host config");
  assert(facade.getConfig("port") == "5432", "Should get port config");
  assert(facade.getConfig("unknown") == "", "Unknown key should return empty");
  assert(facade.getConfig("unknown", "default") == "default", "Should return default value");

  auto retrievedConfig = facade.configuration();
  assert(retrievedConfig.length == 3, "Should have 3 config entries");
}

// Test simple facade with delegates
unittest {
  int initCount = 0;
  int shutdownCount = 0;

  auto facade = createSimpleFacade(
    () {
      initCount++;
      return true;
    },
    () {
      shutdownCount++;
    }
  );

  assert(!facade.isReady(), "Should not be ready initially");

  assert(facade.initialize(), "Should initialize successfully");
  assert(initCount == 1, "Init should be called once");
  assert(facade.isReady(), "Should be ready");

  // Second init should not call delegate again
  assert(facade.initialize(), "Should return true for already initialized");
  assert(initCount == 1, "Init should still be called only once");

  facade.shutdown();
  assert(shutdownCount == 1, "Shutdown should be called once");
  assert(!facade.isReady(), "Should not be ready after shutdown");
}

// Test facade status reporting
unittest {
  class StatusComponent : SubsystemComponent {
    this(string name) { super(name); }
    override bool initialize() { return true; }
    override void shutdown() {}
  }

  auto facade = new CompositeFacade();
  facade.addComponent(new StatusComponent("DB"));
  facade.addComponent(new StatusComponent("Cache"));

  string initialStatus = facade.status();
  assert(initialStatus == "Inactive", "Status should be Inactive initially");

  facade.initialize();
  string activeStatus = facade.status();
  assert(activeStatus == "Active (2 components)", "Status should show active components");
}

// Test component activity checking
unittest {
  class ActivityComponent : SubsystemComponent {
    this(string name) { super(name); }
    override bool initialize() { return true; }
    override void shutdown() {}
  }

  auto facade = new CompositeFacade();
  facade.addComponent(new ActivityComponent("Service1"));
  facade.addComponent(new ActivityComponent("Service2"));

  assert(!facade.isComponentActive("Service1"), "Component should not be active before init");
  assert(!facade.isComponentActive("Unknown"), "Unknown component should not be active");

  facade.initialize();

  assert(facade.isComponentActive("Service1"), "Service1 should be active");
  assert(facade.isComponentActive("Service2"), "Service2 should be active");
  assert(!facade.isComponentActive("Service3"), "Non-existent component should not be active");

  facade.shutdown();

  assert(!facade.isComponentActive("Service1"), "Service1 should not be active after shutdown");
}

// Test multiple facade operations
unittest {
  class CountingComponent : SubsystemComponent {
    int initCount;
    int shutdownCount;

    this(string name) {
      super(name);
      initCount = 0;
      shutdownCount = 0;
    }

    override bool initialize() {
      initCount++;
      return true;
    }

    override void shutdown() {
      shutdownCount++;
    }
  }

  auto comp1 = new CountingComponent("Comp1");
  auto comp2 = new CountingComponent("Comp2");

  auto facade = new CompositeFacade();
  facade.addComponent(comp1);
  facade.addComponent(comp2);

  facade.initialize();
  assert(comp1.initCount == 1, "Comp1 should be initialized once");
  assert(comp2.initCount == 1, "Comp2 should be initialized once");

  facade.shutdown();
  assert(comp1.shutdownCount == 1, "Comp1 should be shutdown once");
  assert(comp2.shutdownCount == 1, "Comp2 should be shutdown once");

  // Re-initialize
  facade.initialize();
  assert(comp1.initCount == 2, "Comp1 should be initialized twice");
  assert(comp2.initCount == 2, "Comp2 should be initialized twice");
}

// Test null component handling
unittest {
  auto facade = new CompositeFacade();
  facade.addComponent(null); // Should not crash

  assert(facade.initialize(), "Should initialize even with null component");
  assert(facade.components().length == 0, "Should have no components");
}

// Test configuration inheritance
unittest {
  auto facade = new ConfigurableFacade();

  string[string] config1;
  config1["key1"] = "value1";
  config1["key2"] = "value2";

  facade.configure(config1);

  // Modify original config
  config1["key3"] = "value3";

  // Facade config should not be affected
  assert(facade.getConfig("key1") == "value1");
  assert(facade.getConfig("key2") == "value2");
  assert(facade.getConfig("key3") == "");

  // Get configuration and modify
  auto retrieved = facade.configuration();
  retrieved["key4"] = "value4";

  // Original should not be affected
  assert(facade.getConfig("key4") == "");
}
