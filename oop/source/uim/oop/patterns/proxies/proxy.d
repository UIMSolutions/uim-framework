/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.proxies.proxy;

import uim.oop;

mixin(ShowModule!());

@safe:


/**
 * Base abstract class for subjects.
 */
abstract class ProxySubject : IProxySubject {
  /**
   * Execute the subject's main operation.
   */
  abstract string execute() @safe;
}

/**
 * Base proxy class.
 * Forwards requests to the real subject.
 */
abstract class Proxy : IProxy {
  protected IProxySubject _realSubject;

  /**
   * Constructor.
   */
  this(IProxySubject realSubject) @safe {
    _realSubject = realSubject;
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe {
    return _realSubject;
  }

  /**
   * Execute by delegating to real subject.
   */
  string execute() @safe {
    return _realSubject.execute();
  }
}



/**
 * Protection Proxy for access control.
 * Controls access to the real subject based on permissions.
 */
class ProtectionProxy : IProtectionProxy {
  private IProxySubject _realSubject;
  private bool _accessAllowed;

  /**
   * Constructor.
   */
  this(IProxySubject realSubject, bool accessAllowed = true) @safe {
    _realSubject = realSubject;
    _accessAllowed = accessAllowed;
  }

  /**
   * Check if access is allowed.
   */
  bool isAccessAllowed() @safe {
    return _accessAllowed;
  }

  /**
   * Set access permission.
   */
  void setAccessAllowed(bool allowed) @safe {
    _accessAllowed = allowed;
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe {
    return _realSubject;
  }

  /**
   * Execute if access is allowed.
   */
  string execute() @safe {
    if (_accessAllowed) {
      return _realSubject.execute();
    }
    return "Access denied";
  }
}

/**
 * Caching Proxy for performance optimization.
 * Caches the result of expensive operations.
 */
class CachingProxy : ICachingProxy {
  private IProxySubject _realSubject;
  private string _cachedResult;
  private bool _isCached;

  /**
   * Constructor.
   */
  this(IProxySubject realSubject) @safe {
    _realSubject = realSubject;
    _isCached = false;
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe {
    return _realSubject;
  }

  /**
   * Check if result is cached.
   */
  bool isCached() @safe {
    return _isCached;
  }

  /**
   * Clear the cache.
   */
  void clearCache() @safe {
    _cachedResult = "";
    _isCached = false;
  }

  /**
   * Execute with caching.
   */
  string execute() @safe {
    if (!_isCached) {
      _cachedResult = _realSubject.execute();
      _isCached = true;
    }
    return _cachedResult;
  }
}

/**
 * Logging Proxy for monitoring.
 * Logs all accesses to the real subject.
 */
class LoggingProxy : ILoggingProxy {
  private IProxySubject _realSubject;
  private string[] _log;

  /**
   * Constructor.
   */
  this(IProxySubject realSubject) @safe {
    _realSubject = realSubject;
    _log = [];
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe {
    return _realSubject;
  }

  /**
   * Get the access log.
   */
  string[] getLog() @safe {
    return _log;
  }

  /**
   * Clear the log.
   */
  void clearLog() @safe {
    _log = [];
  }

  /**
   * Execute with logging.
   */
  string execute() @safe {
    import std.datetime : Clock;
    auto timestamp = Clock.currTime().toISOExtString();
    _log ~= "Access at " ~ timestamp;
    auto result = _realSubject.execute();
    _log ~= "Result: " ~ result;
    return result;
  }
}

/**
 * Remote Proxy for network operations.
 * Simulates remote object access.
 */
class RemoteProxy : IRemoteProxy {
  private IProxySubject _realSubject;
  private string _endpoint;
  private bool _connected;

  /**
   * Constructor.
   */
  this(IProxySubject realSubject, string endpoint) @safe {
    _realSubject = realSubject;
    _endpoint = endpoint;
    _connected = false;
  }

  /**
   * Get the remote endpoint.
   */
  string getEndpoint() @safe {
    return _endpoint;
  }

  /**
   * Check connection status.
   */
  bool isConnected() @safe {
    return _connected;
  }

  /**
   * Connect to remote endpoint.
   */
  void connect() @safe {
    _connected = true;
  }

  /**
   * Disconnect from remote endpoint.
   */
  void disconnect() @safe {
    _connected = false;
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe {
    return _realSubject;
  }

  /**
   * Execute with remote access simulation.
   */
  string execute() @safe {
    if (!_connected) {
      connect();
    }
    auto result = "Remote[" ~ _endpoint ~ "]: " ~ _realSubject.execute();
    return result;
  }
}

/**
 * Smart Reference Proxy.
 * Performs additional actions when accessing the real subject.
 */
class SmartReferenceProxy : IProxy {
  private IProxySubject _realSubject;
  private int _accessCount;

  /**
   * Constructor.
   */
  this(IProxySubject realSubject) @safe {
    _realSubject = realSubject;
    _accessCount = 0;
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe {
    return _realSubject;
  }

  /**
   * Get access count.
   */
  int getAccessCount() @safe {
    return _accessCount;
  }

  /**
   * Reset access count.
   */
  void resetAccessCount() @safe {
    _accessCount = 0;
  }

  /**
   * Execute with reference counting.
   */
  string execute() @safe {
    _accessCount++;
    return _realSubject.execute();
  }
}

// Unit Tests

@safe unittest {
  // Test basic proxy
  class RealSubject : ProxySubject {
    override string execute() {
      return "Real subject executed";
    }
  }

  class BasicProxy : Proxy {
    this(IProxySubject realSubject) {
      super(realSubject);
    }
  }

  auto realSubject = new RealSubject();
  auto proxy = new BasicProxy(realSubject);

  assert(proxy.execute() == "Real subject executed");
  assert(proxy.getRealSubject() is realSubject);
}

@safe unittest {
  // Test virtual proxy (lazy initialization)
  class ExpensiveSubject : ProxySubject {
    override string execute() {
      return "Expensive operation";
    }
  }

  auto proxy = new VirtualProxy(() => cast(IProxySubject) new ExpensiveSubject());
  assert(!proxy.isInitialized(), "Should not be initialized yet");

  auto result = proxy.execute();
  assert(result == "Expensive operation");
  assert(proxy.isInitialized(), "Should be initialized after first use");
}

@safe unittest {
  // Test protection proxy
  class SecureSubject : ProxySubject {
    override string execute() {
      return "Secure data";
    }
  }

  auto realSubject = new SecureSubject();
  auto proxy = new ProtectionProxy(realSubject, true);

  assert(proxy.isAccessAllowed());
  assert(proxy.execute() == "Secure data");

  proxy.setAccessAllowed(false);
  assert(!proxy.isAccessAllowed());
  assert(proxy.execute() == "Access denied");
}

@safe unittest {
  // Test caching proxy
  class DataSubject : ProxySubject {
    private int _callCount = 0;

    override string execute() {
      _callCount++;
      return "Data fetched";
    }

    int getCallCount() @safe {
      return _callCount;
    }
  }

  auto realSubject = new DataSubject();
  auto proxy = new CachingProxy(realSubject);

  assert(!proxy.isCached());

  auto result1 = proxy.execute();
  assert(result1 == "Data fetched");
  assert(proxy.isCached());
  assert(realSubject.getCallCount() == 1);

  // Second call should use cache
  auto result2 = proxy.execute();
  assert(result2 == "Data fetched");
  assert(realSubject.getCallCount() == 1); // Still 1, not called again

  proxy.clearCache();
  assert(!proxy.isCached());
}

@safe unittest {
  // Test logging proxy
  class SimpleSubject : ProxySubject {
    override string execute() {
      return "Operation completed";
    }
  }

  auto realSubject = new SimpleSubject();
  auto proxy = new LoggingProxy(realSubject);

  assert(proxy.getLog().length == 0);

  auto result = proxy.execute();
  assert(result == "Operation completed");
  assert(proxy.getLog().length > 0);

  proxy.clearLog();
  assert(proxy.getLog().length == 0);
}

@safe unittest {
  // Test remote proxy
  class ServiceSubject : ProxySubject {
    override string execute() {
      return "Service response";
    }
  }

  auto realSubject = new ServiceSubject();
  auto proxy = new RemoteProxy(realSubject, "https://api.example.com");

  assert(proxy.getEndpoint() == "https://api.example.com");
  assert(!proxy.isConnected());

  auto result = proxy.execute();
  assert(result.length > 0);
  assert(proxy.isConnected());
}

@safe unittest {
  // Test smart reference proxy
  class ResourceSubject : ProxySubject {
    override string execute() {
      return "Resource accessed";
    }
  }

  auto realSubject = new ResourceSubject();
  auto proxy = new SmartReferenceProxy(realSubject);

  assert(proxy.getAccessCount() == 0);

  proxy.execute();
  assert(proxy.getAccessCount() == 1);

  proxy.execute();
  assert(proxy.getAccessCount() == 2);

  proxy.resetAccessCount();
  assert(proxy.getAccessCount() == 0);
}
