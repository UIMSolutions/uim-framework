/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.proxies.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

// Test Subjects

class DatabaseService : ProxySubject {
  private string _connectionString;

  this(string connectionString) {
    _connectionString = connectionString;
  }

  override string execute() {
    return "Database query executed on " ~ _connectionString;
  }
}

class ImageService : ProxySubject {
  private string _imagePath;

  this(string imagePath) {
    _imagePath = imagePath;
  }

  override string execute() {
    return "Image loaded from " ~ _imagePath;
  }
}

class APIService : ProxySubject {
  private string _endpoint;

  this(string endpoint) {
    _endpoint = endpoint;
  }

  override string execute() {
    return "API call to " ~ _endpoint;
  }
}

class ExpensiveCalculation : ProxySubject {
  private int _value;

  this(int value) {
    _value = value;
  }

  override string execute() {
    import std.conv : to;
    // Simulate expensive computation
    int result = _value * _value;
    return "Calculation result: " ~ result.to!string;
  }
}

class SecureDocument : ProxySubject {
  private string _content;

  this(string content) {
    _content = content;
  }

  override string execute() {
    return "Document content: " ~ _content;
  }
}

// Comprehensive Tests

@safe unittest {
  mixin(ShowTest!("Virtual Proxy - Lazy initialization"));

  int creationCount = 0;

  auto proxy = new VirtualProxy(() {
    creationCount++;
    return cast(IProxySubject) new DatabaseService("localhost:5432");
  });

  assert(!proxy.isInitialized(), "Proxy should not be initialized");
  assert(creationCount == 0, "Real subject should not be created yet");

  auto result = proxy.execute();
  assert(proxy.isInitialized(), "Proxy should be initialized after first use");
  assert(creationCount == 1, "Real subject should be created once");
  assert(result.length > 0, "Should return valid result");

  // Second call should reuse the same instance
  proxy.execute();
  assert(creationCount == 1, "Real subject should not be recreated");
}

@safe unittest {
  mixin(ShowTest!("Virtual Proxy - Image loading"));

  auto imageProxy = new VirtualProxy(() {
    return cast(IProxySubject) new ImageService("/path/to/large/image.jpg");
  });

  assert(!imageProxy.isInitialized(), "Image should not be loaded yet");

  auto result = imageProxy.execute();
  assert(imageProxy.isInitialized(), "Image should be loaded");
  assert(result.length > 0, "Should return image path info");
}

@safe unittest {
  mixin(ShowTest!("Protection Proxy - Access control"));

  auto document = new SecureDocument("Classified Information");
  auto proxy = new ProtectionProxy(document, false);

  assert(!proxy.isAccessAllowed(), "Access should be denied initially");

  auto result = proxy.execute();
  assert(result == "Access denied", "Should deny access");

  proxy.setAccessAllowed(true);
  assert(proxy.isAccessAllowed(), "Access should be allowed");

  result = proxy.execute();
  assert(result == "Document content: Classified Information", "Should allow access");
}

@safe unittest {
  mixin(ShowTest!("Protection Proxy - Role-based access"));

  auto service = new DatabaseService("prod-db:5432");
  
  // Admin has access
  auto adminProxy = new ProtectionProxy(service, true);
  auto adminResult = adminProxy.execute();
  assert(adminResult.length > 0 && adminResult != "Access denied");

  // Guest does not have access
  auto guestProxy = new ProtectionProxy(service, false);
  auto guestResult = guestProxy.execute();
  assert(guestResult == "Access denied");
}

@safe unittest {
  mixin(ShowTest!("Caching Proxy - Performance optimization"));

  auto calculation = new ExpensiveCalculation(42);
  auto proxy = new CachingProxy(calculation);

  assert(!proxy.isCached(), "Result should not be cached initially");

  auto result1 = proxy.execute();
  assert(proxy.isCached(), "Result should be cached after first execution");
  assert(result1 == "Calculation result: 1764");

  auto result2 = proxy.execute();
  assert(result1 == result2, "Cached result should be the same");

  proxy.clearCache();
  assert(!proxy.isCached(), "Cache should be cleared");
}

@safe unittest {
  mixin(ShowTest!("Caching Proxy - Multiple calls"));

  auto service = new APIService("https://api.example.com/data");
  auto proxy = new CachingProxy(service);

  // First call - not cached
  auto result1 = proxy.execute();
  assert(proxy.isCached());

  // Multiple subsequent calls - all from cache
  for (int i = 0; i < 10; i++) {
    auto result = proxy.execute();
    assert(result == result1, "All results should be identical");
  }
}

@safe unittest {
  mixin(ShowTest!("Logging Proxy - Access tracking"));

  auto service = new DatabaseService("localhost:5432");
  auto proxy = new LoggingProxy(service);

  assert(proxy.getLog().length == 0, "Log should be empty initially");

  proxy.execute();
  auto log = proxy.getLog();
  assert(log.length > 0, "Log should contain entries");

  proxy.execute();
  log = proxy.getLog();
  assert(log.length > 2, "Log should grow with each access");

  proxy.clearLog();
  assert(proxy.getLog().length == 0, "Log should be cleared");
}

@safe unittest {
  mixin(ShowTest!("Logging Proxy - Audit trail"));

  auto document = new SecureDocument("Sensitive data");
  auto proxy = new LoggingProxy(document);

  // Multiple accesses
  proxy.execute();
  proxy.execute();
  proxy.execute();

  auto log = proxy.getLog();
  assert(log.length >= 3, "Should log all accesses");
}

@safe unittest {
  mixin(ShowTest!("Remote Proxy - Network simulation"));

  auto service = new APIService("/api/users");
  auto proxy = new RemoteProxy(service, "https://remote.example.com");

  assert(proxy.getEndpoint() == "https://remote.example.com");
  assert(!proxy.isConnected(), "Should not be connected initially");

  auto result = proxy.execute();
  assert(proxy.isConnected(), "Should be connected after execution");
  assert(result.length > 0, "Should return result");
}

@safe unittest {
  mixin(ShowTest!("Remote Proxy - Multiple endpoints"));

  auto service1 = new DatabaseService("db1");
  auto proxy1 = new RemoteProxy(service1, "server1.example.com");

  auto service2 = new DatabaseService("db2");
  auto proxy2 = new RemoteProxy(service2, "server2.example.com");

  assert(proxy1.getEndpoint() != proxy2.getEndpoint());

  proxy1.execute();
  proxy2.execute();

  assert(proxy1.isConnected());
  assert(proxy2.isConnected());
}

@safe unittest {
  mixin(ShowTest!("Smart Reference Proxy - Reference counting"));

  auto service = new DatabaseService("localhost:5432");
  auto proxy = new SmartReferenceProxy(service);

  assert(proxy.getAccessCount() == 0, "Count should be zero initially");

  proxy.execute();
  assert(proxy.getAccessCount() == 1, "Count should increment");

  proxy.execute();
  assert(proxy.getAccessCount() == 2, "Count should increment again");

  proxy.resetAccessCount();
  assert(proxy.getAccessCount() == 0, "Count should be reset");
}

@safe unittest {
  mixin(ShowTest!("Smart Reference Proxy - Resource management"));

  auto image = new ImageService("large-file.jpg");
  auto proxy = new SmartReferenceProxy(image);

  for (int i = 0; i < 5; i++) {
    proxy.execute();
  }

  assert(proxy.getAccessCount() == 5, "Should track all accesses");
}

@safe unittest {
  mixin(ShowTest!("Proxy chaining - Multiple proxies"));

  auto realService = new DatabaseService("prod-db:5432");

  // Chain: Protection -> Caching -> Logging
  auto protectionProxy = new ProtectionProxy(realService, true);
  auto cachingProxy = new CachingProxy(protectionProxy);
  auto loggingProxy = new LoggingProxy(cachingProxy);

  auto result = loggingProxy.execute();
  assert(result.length > 0);
  assert(loggingProxy.getLog().length > 0, "Should log access");
}

@safe unittest {
  mixin(ShowTest!("Proxy chaining - Virtual + Caching"));

  auto virtualProxy = new VirtualProxy(() {
    return cast(IProxySubject) new ExpensiveCalculation(100);
  });

  auto cachingProxy = new CachingProxy(virtualProxy);

  assert(!virtualProxy.isInitialized(), "Should not be initialized");
  assert(!cachingProxy.isCached(), "Should not be cached");

  auto result = cachingProxy.execute();
  assert(virtualProxy.isInitialized(), "Should be initialized");
  assert(cachingProxy.isCached(), "Should be cached");

  auto result2 = cachingProxy.execute();
  assert(result == result2, "Should return cached result");
}

@safe unittest {
  mixin(ShowTest!("Real-world scenario - Secure API with logging"));

  auto apiService = new APIService("/api/sensitive/data");

  // Add protection
  auto protectedAPI = new ProtectionProxy(apiService, false);
  
  // Add logging
  auto loggedAPI = new LoggingProxy(protectedAPI);

  // Attempt access without permission
  auto result1 = loggedAPI.execute();
  assert(result1 == "Access denied");
  assert(loggedAPI.getLog().length > 0, "Should log denied access");

  // Grant permission
  protectedAPI.setAccessAllowed(true);

  // Access with permission
  auto result2 = loggedAPI.execute();
  assert(result2 != "Access denied");
  assert(loggedAPI.getLog().length > 2, "Should log successful access");
}

@safe unittest {
  mixin(ShowTest!("Real-world scenario - Lazy image loading with caching"));

  auto imageProxy = new VirtualProxy(() {
    return cast(IProxySubject) new ImageService("/images/large-photo.jpg");
  });

  auto cachedImageProxy = new CachingProxy(imageProxy);

  // First access - loads and caches
  assert(!imageProxy.isInitialized());
  assert(!cachedImageProxy.isCached());

  auto result1 = cachedImageProxy.execute();
  assert(imageProxy.isInitialized(), "Image should be loaded");
  assert(cachedImageProxy.isCached(), "Result should be cached");

  // Subsequent accesses - from cache
  auto result2 = cachedImageProxy.execute();
  assert(result1 == result2);
}

@safe unittest {
  mixin(ShowTest!("Real-world scenario - Database connection pool simulation"));

  auto db1 = new DatabaseService("connection-1");
  auto db2 = new DatabaseService("connection-2");
  auto db3 = new DatabaseService("connection-3");

  auto proxy1 = new SmartReferenceProxy(db1);
  auto proxy2 = new SmartReferenceProxy(db2);
  auto proxy3 = new SmartReferenceProxy(db3);

  // Simulate multiple requests
  proxy1.execute();
  proxy1.execute();
  proxy2.execute();
  proxy3.execute();
  proxy1.execute();

  assert(proxy1.getAccessCount() == 3, "Connection 1 used 3 times");
  assert(proxy2.getAccessCount() == 1, "Connection 2 used 1 time");
  assert(proxy3.getAccessCount() == 1, "Connection 3 used 1 time");
}
