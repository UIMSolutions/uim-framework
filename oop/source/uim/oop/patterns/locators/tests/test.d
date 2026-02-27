/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.locators.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

// Test Object implementations

class EmailObject : LocatorObject {
  private string _recipient;

  this() {
    super("EmailObject");
    _recipient = "";
  }

  void setRecipient(string recipient) {
    _recipient = recipient;
  }

  string recipient() {
    return _recipient;
  }

  override string execute() {
    return "Email sent to " ~ _recipient;
  }
}

class DatabaseObject : LocatorObject {
  private string _connectionString;

  this() {
    super("DatabaseObject");
    _connectionString = "localhost:5432";
  }

  void setConnectionString(string connStr) {
    _connectionString = connStr;
  }

  string connectionString() {
    return _connectionString;
  }

  override string execute() {
    return "Connected to database: " ~ _connectionString;
  }
}

class LoggingObject : LocatorObject {
  private string _logLevel;

  this() {
    super("LoggingObject");
    _logLevel = "INFO";
  }

  void setLogLevel(string level) {
    _logLevel = level;
  }

  string logLevel() {
    return _logLevel;
  }

  override string execute() {
    return "Logging at level: " ~ _logLevel;
  }
}

class CacheObject : LocatorObject {
  private size_t _capacity;

  this() {
    super("CacheObject");
    _capacity = 100;
  }

  void setCapacity(size_t cap) {
    _capacity = cap;
  }

  size_t capacity() {
    return _capacity;
  }

  override string execute() {
    import std.conv : to;
    return "Cache capacity: " ~ _capacity.to!string;
  }
}

// Comprehensive Tests

@safe unittest {
  mixin(ShowTest!("Basic ObjectLocator registration and retrieval"));

  auto locator = new ObjectLocator();
  auto emailObject = new EmailObject();
  emailObject.setRecipient("test@example.com");

  locator.registerObject("email", emailObject);
  assert(locator.hasObject("email"), "Object should be registered");

  auto retrieved = cast(EmailObject) locator.getObject("email");
  assert(retrieved !is null, "Object should be retrievable");
  assert(retrieved.recipient() == "test@example.com", "Object state should be preserved");
  assert(retrieved.execute().length > 0, "Object should be executable");
}

@safe unittest {
  mixin(ShowTest!("ObjectLocator multiple objects"));

  auto locator = new ObjectLocator();
  auto emailObject = new EmailObject();
  auto dbObject = new DatabaseObject();
  auto logObject = new LoggingObject();

  locator.registerObject("email", emailObject);
  locator.registerObject("database", dbObject);
  locator.registerObject("logging", logObject);

  assert(locator.hasObject("email"));
  assert(locator.hasObject("database"));
  assert(locator.hasObject("logging"));

  auto names = locator.getObjectNames();
  assert(names.length == 3, "Should have 3 registered objects");
}

@safe unittest {
  mixin(ShowTest!("ObjectLocator unregister object"));

  auto locator = new ObjectLocator();
  auto object = new EmailObject();

  locator.registerObject("email", object);
  assert(locator.hasObject("email"));

  bool removed = locator.unregisterObject("email");
  assert(removed, "Object should be removed");
  assert(!locator.hasObject("email"), "Object should no longer be registered");

  bool removedAgain = locator.unregisterObject("email");
  assert(!removedAgain, "Removing non-existent object should return false");
}

@safe unittest {
  mixin(ShowTest!("ObjectLocator clear all objects"));

  auto locator = new ObjectLocator();
  locator.registerObject("email", new EmailObject());
  locator.registerObject("database", new DatabaseObject());

  assert(locator.getObjectNames().length == 2);

  locator.clear();
  assert(locator.getObjectNames().length == 0, "All objects should be cleared");
  assert(!locator.hasObject("email"));
  assert(!locator.hasObject("database"));
}

@safe unittest {
  mixin(ShowTest!("LazyObjectLocator factory registration"));

  auto locator = new LazyObjectLocator();

  locator.registerFactory("email", () {
    auto svc = new EmailObject();
    svc.setRecipient("lazy@example.com");
    return cast(IObject) svc;
  });

  assert(locator.hasObject("email"), "Factory-registered object should be available");

  auto object = cast(EmailObject) locator.getObject("email");
  assert(object !is null, "Object should be created");
  assert(object.recipient() == "lazy@example.com", "Object should be initialized correctly");

  // Second call should return same instance
  auto object2 = locator.getObject("email");
  assert(object is object2, "Should return cached instance");
}

@safe unittest {
  mixin(ShowTest!("LazyObjectLocator mixed registration"));

  auto locator = new LazyObjectLocator();

  // Register immediate object
  auto emailObject = new EmailObject();
  locator.registerObject("email", emailObject);

  // Register lazy object
  locator.registerFactory("database", () => cast(IObject) new DatabaseObject());

  assert(locator.hasObject("email"));
  assert(locator.hasObject("database"));

  auto email = locator.getObject("email");
  auto db = locator.getObject("database");

  assert(email !is null);
  assert(db !is null);
}

@safe unittest {
  mixin(ShowTest!("CachedObjectLocator caching behavior"));

  auto locator = new CachedObjectLocator();
  assert(locator.isCacheEnabled(), "Cache should be enabled by default");

  auto object = new EmailObject();
  locator.registerObject("email", object);

  auto retrieved1 = locator.getObject("email");
  auto retrieved2 = locator.getObject("email");

  assert(retrieved1 is retrieved2, "Should return same cached instance");

  locator.clearCache();
  auto retrieved3 = locator.getObject("email");
  assert(retrieved3 !is null, "Object should still be available after cache clear");
}

@safe unittest {
  mixin(ShowTest!("CachedObjectLocator disable caching"));

  auto locator = new CachedObjectLocator();
  locator.setCacheEnabled(false);
  assert(!locator.isCacheEnabled(), "Cache should be disabled");

  auto object = new EmailObject();
  locator.registerObject("email", object);

  auto retrieved = locator.getObject("email");
  assert(retrieved !is null, "Object should be retrievable without cache");

  locator.setCacheEnabled(true);
  assert(locator.isCacheEnabled(), "Cache should be re-enabled");
}

@safe unittest {
  mixin(ShowTest!("HierarchicalObjectLocator parent-child relationship"));

  auto parentLocator = new HierarchicalObjectLocator();
  auto childLocator = new HierarchicalObjectLocator(parentLocator);

  // Register object in parent
  parentLocator.registerObject("logging", new LoggingObject());

  // Register object in child
  childLocator.registerObject("email", new EmailObject());

  // Child can access its own object
  assert(childLocator.hasObject("email"));
  auto emailSvc = childLocator.getObject("email");
  assert(emailSvc !is null);

  // Child can access parent's object
  assert(childLocator.hasObject("logging"));
  auto logSvc = childLocator.getObject("logging");
  assert(logSvc !is null);
  assert(logSvc.objectName() == "LoggingObject");

  // Parent cannot access child's object
  assert(!parentLocator.hasObject("email"));
}

@safe unittest {
  mixin(ShowTest!("HierarchicalObjectLocator multi-level hierarchy"));

  auto rootLocator = new HierarchicalObjectLocator();
  auto middleLocator = new HierarchicalObjectLocator(rootLocator);
  auto leafLocator = new HierarchicalObjectLocator(middleLocator);

  rootLocator.registerObject("root", new LoggingObject());
  middleLocator.registerObject("middle", new DatabaseObject());
  leafLocator.registerObject("leaf", new EmailObject());

  // Leaf can access all levels
  assert(leafLocator.hasObject("leaf"));
  assert(leafLocator.hasObject("middle"));
  assert(leafLocator.hasObject("root"));

  auto rootSvc = leafLocator.getObject("root");
  assert(rootSvc !is null);
}

@safe unittest {
  mixin(ShowTest!("HierarchicalObjectLocator object shadowing"));

  auto parentLocator = new HierarchicalObjectLocator();
  auto childLocator = new HierarchicalObjectLocator(parentLocator);

  // Register same object name in both
  auto parentEmail = new EmailObject();
  parentEmail.setRecipient("parent@example.com");
  parentLocator.registerObject("email", parentEmail);

  auto childEmail = new EmailObject();
  childEmail.setRecipient("child@example.com");
  childLocator.registerObject("email", childEmail);

  // Child should get its own object (shadowing parent's)
  auto retrieved = cast(EmailObject) childLocator.getObject("email");
  assert(retrieved !is null);
  assert(retrieved.recipient() == "child@example.com", "Child object should shadow parent");
}

@safe unittest {
  mixin(ShowTest!("ObjectLocator object replacement"));

  auto locator = new ObjectLocator();
  
  auto object1 = new EmailObject();
  object1.setRecipient("first@example.com");
  locator.registerObject("email", object1);

  auto retrieved1 = cast(EmailObject) locator.getObject("email");
  assert(retrieved1.recipient() == "first@example.com");

  // Replace with new object
  auto object2 = new EmailObject();
  object2.setRecipient("second@example.com");
  locator.registerObject("email", object2);

  auto retrieved2 = cast(EmailObject) locator.getObject("email");
  assert(retrieved2.recipient() == "second@example.com", "Object should be replaced");
}

@safe unittest {
  mixin(ShowTest!("Real-world scenario: Application with multiple objects"));

  // Create application object locator
  auto appLocator = new CachedObjectLocator();

  // Register application objects
  auto dbObject = new DatabaseObject();
  dbObject.setConnectionString("prod-db.example.com:5432");
  appLocator.registerObject("database", dbObject);

  auto emailObject = new EmailObject();
  emailObject.setRecipient("admin@example.com");
  appLocator.registerObject("email", emailObject);

  auto logObject = new LoggingObject();
  logObject.setLogLevel("ERROR");
  appLocator.registerObject("logging", logObject);

  auto cacheObject = new CacheObject();
  cacheObject.setCapacity(1000);
  appLocator.registerObject("cache", cacheObject);

  // Simulate application using objects
  assert(appLocator.getObjectNames().length == 4);

  auto db = cast(DatabaseObject) appLocator.getObject("database");
  assert(db !is null);
  assert(db.connectionString().length > 0);

  auto log = cast(LoggingObject) appLocator.getObject("logging");
  assert(log !is null);
  assert(log.logLevel() == "ERROR");

  // Objects should be cached
  auto db2 = appLocator.getObject("database");
  assert(db is db2, "Should return cached instance");
}
