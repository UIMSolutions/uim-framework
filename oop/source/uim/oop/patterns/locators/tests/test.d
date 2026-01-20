/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.locators.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

// Test Service implementations

class EmailService : Service {
  private string _recipient;

  this() {
    super("EmailService");
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

class DatabaseService : Service {
  private string _connectionString;

  this() {
    super("DatabaseService");
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

class LoggingService : Service {
  private string _logLevel;

  this() {
    super("LoggingService");
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

class CacheService : Service {
  private size_t _capacity;

  this() {
    super("CacheService");
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
  mixin(ShowTest!("Basic ServiceLocator registration and retrieval"));

  auto locator = new ServiceLocator();
  auto emailService = new EmailService();
  emailService.setRecipient("test@example.com");

  locator.registerService("email", emailService);
  assert(locator.hasService("email"), "Service should be registered");

  auto retrieved = cast(EmailService) locator.getService("email");
  assert(retrieved !is null, "Service should be retrievable");
  assert(retrieved.recipient() == "test@example.com", "Service state should be preserved");
  assert(retrieved.execute().length > 0, "Service should be executable");
}

@safe unittest {
  mixin(ShowTest!("ServiceLocator multiple services"));

  auto locator = new ServiceLocator();
  auto emailService = new EmailService();
  auto dbService = new DatabaseService();
  auto logService = new LoggingService();

  locator.registerService("email", emailService);
  locator.registerService("database", dbService);
  locator.registerService("logging", logService);

  assert(locator.hasService("email"));
  assert(locator.hasService("database"));
  assert(locator.hasService("logging"));

  auto names = locator.getServiceNames();
  assert(names.length == 3, "Should have 3 registered services");
}

@safe unittest {
  mixin(ShowTest!("ServiceLocator unregister service"));

  auto locator = new ServiceLocator();
  auto service = new EmailService();

  locator.registerService("email", service);
  assert(locator.hasService("email"));

  bool removed = locator.unregisterService("email");
  assert(removed, "Service should be removed");
  assert(!locator.hasService("email"), "Service should no longer be registered");

  bool removedAgain = locator.unregisterService("email");
  assert(!removedAgain, "Removing non-existent service should return false");
}

@safe unittest {
  mixin(ShowTest!("ServiceLocator clear all services"));

  auto locator = new ServiceLocator();
  locator.registerService("email", new EmailService());
  locator.registerService("database", new DatabaseService());

  assert(locator.getServiceNames().length == 2);

  locator.clear();
  assert(locator.getServiceNames().length == 0, "All services should be cleared");
  assert(!locator.hasService("email"));
  assert(!locator.hasService("database"));
}

@safe unittest {
  mixin(ShowTest!("LazyServiceLocator factory registration"));

  auto locator = new LazyServiceLocator();

  locator.registerFactory("email", () {
    auto svc = new EmailService();
    svc.setRecipient("lazy@example.com");
    return cast(IService) svc;
  });

  assert(locator.hasService("email"), "Factory-registered service should be available");

  auto service = cast(EmailService) locator.getService("email");
  assert(service !is null, "Service should be created");
  assert(service.recipient() == "lazy@example.com", "Service should be initialized correctly");

  // Second call should return same instance
  auto service2 = locator.getService("email");
  assert(service is service2, "Should return cached instance");
}

@safe unittest {
  mixin(ShowTest!("LazyServiceLocator mixed registration"));

  auto locator = new LazyServiceLocator();

  // Register immediate service
  auto emailService = new EmailService();
  locator.registerService("email", emailService);

  // Register lazy service
  locator.registerFactory("database", () => cast(IService) new DatabaseService());

  assert(locator.hasService("email"));
  assert(locator.hasService("database"));

  auto email = locator.getService("email");
  auto db = locator.getService("database");

  assert(email !is null);
  assert(db !is null);
}

@safe unittest {
  mixin(ShowTest!("CachedServiceLocator caching behavior"));

  auto locator = new CachedServiceLocator();
  assert(locator.isCacheEnabled(), "Cache should be enabled by default");

  auto service = new EmailService();
  locator.registerService("email", service);

  auto retrieved1 = locator.getService("email");
  auto retrieved2 = locator.getService("email");

  assert(retrieved1 is retrieved2, "Should return same cached instance");

  locator.clearCache();
  auto retrieved3 = locator.getService("email");
  assert(retrieved3 !is null, "Service should still be available after cache clear");
}

@safe unittest {
  mixin(ShowTest!("CachedServiceLocator disable caching"));

  auto locator = new CachedServiceLocator();
  locator.setCacheEnabled(false);
  assert(!locator.isCacheEnabled(), "Cache should be disabled");

  auto service = new EmailService();
  locator.registerService("email", service);

  auto retrieved = locator.getService("email");
  assert(retrieved !is null, "Service should be retrievable without cache");

  locator.setCacheEnabled(true);
  assert(locator.isCacheEnabled(), "Cache should be re-enabled");
}

@safe unittest {
  mixin(ShowTest!("HierarchicalServiceLocator parent-child relationship"));

  auto parentLocator = new HierarchicalServiceLocator();
  auto childLocator = new HierarchicalServiceLocator(parentLocator);

  // Register service in parent
  parentLocator.registerService("logging", new LoggingService());

  // Register service in child
  childLocator.registerService("email", new EmailService());

  // Child can access its own service
  assert(childLocator.hasService("email"));
  auto emailSvc = childLocator.getService("email");
  assert(emailSvc !is null);

  // Child can access parent's service
  assert(childLocator.hasService("logging"));
  auto logSvc = childLocator.getService("logging");
  assert(logSvc !is null);
  assert(logSvc.serviceName() == "LoggingService");

  // Parent cannot access child's service
  assert(!parentLocator.hasService("email"));
}

@safe unittest {
  mixin(ShowTest!("HierarchicalServiceLocator multi-level hierarchy"));

  auto rootLocator = new HierarchicalServiceLocator();
  auto middleLocator = new HierarchicalServiceLocator(rootLocator);
  auto leafLocator = new HierarchicalServiceLocator(middleLocator);

  rootLocator.registerService("root", new LoggingService());
  middleLocator.registerService("middle", new DatabaseService());
  leafLocator.registerService("leaf", new EmailService());

  // Leaf can access all levels
  assert(leafLocator.hasService("leaf"));
  assert(leafLocator.hasService("middle"));
  assert(leafLocator.hasService("root"));

  auto rootSvc = leafLocator.getService("root");
  assert(rootSvc !is null);
}

@safe unittest {
  mixin(ShowTest!("HierarchicalServiceLocator service shadowing"));

  auto parentLocator = new HierarchicalServiceLocator();
  auto childLocator = new HierarchicalServiceLocator(parentLocator);

  // Register same service name in both
  auto parentEmail = new EmailService();
  parentEmail.setRecipient("parent@example.com");
  parentLocator.registerService("email", parentEmail);

  auto childEmail = new EmailService();
  childEmail.setRecipient("child@example.com");
  childLocator.registerService("email", childEmail);

  // Child should get its own service (shadowing parent's)
  auto retrieved = cast(EmailService) childLocator.getService("email");
  assert(retrieved !is null);
  assert(retrieved.recipient() == "child@example.com", "Child service should shadow parent");
}

@safe unittest {
  mixin(ShowTest!("ServiceLocator service replacement"));

  auto locator = new ServiceLocator();
  
  auto service1 = new EmailService();
  service1.setRecipient("first@example.com");
  locator.registerService("email", service1);

  auto retrieved1 = cast(EmailService) locator.getService("email");
  assert(retrieved1.recipient() == "first@example.com");

  // Replace with new service
  auto service2 = new EmailService();
  service2.setRecipient("second@example.com");
  locator.registerService("email", service2);

  auto retrieved2 = cast(EmailService) locator.getService("email");
  assert(retrieved2.recipient() == "second@example.com", "Service should be replaced");
}

@safe unittest {
  mixin(ShowTest!("Real-world scenario: Application with multiple services"));

  // Create application service locator
  auto appLocator = new CachedServiceLocator();

  // Register application services
  auto dbService = new DatabaseService();
  dbService.setConnectionString("prod-db.example.com:5432");
  appLocator.registerService("database", dbService);

  auto emailService = new EmailService();
  emailService.setRecipient("admin@example.com");
  appLocator.registerService("email", emailService);

  auto logService = new LoggingService();
  logService.setLogLevel("ERROR");
  appLocator.registerService("logging", logService);

  auto cacheService = new CacheService();
  cacheService.setCapacity(1000);
  appLocator.registerService("cache", cacheService);

  // Simulate application using services
  assert(appLocator.getServiceNames().length == 4);

  auto db = cast(DatabaseService) appLocator.getService("database");
  assert(db !is null);
  assert(db.connectionString().length > 0);

  auto log = cast(LoggingService) appLocator.getService("logging");
  assert(log !is null);
  assert(log.logLevel() == "ERROR");

  // Services should be cached
  auto db2 = appLocator.getService("database");
  assert(db is db2, "Should return cached instance");
}
