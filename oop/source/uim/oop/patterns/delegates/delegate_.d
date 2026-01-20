/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.delegates.delegate_;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Business Lookup Service implementation.
 * Manages registration and lookup of business services.
 */
class BusinessLookup : IBusinessLookup {
  private IBusinessService[string] _services;

  /**
   * Look up a business service by name.
   */
  IBusinessService getBusinessService(string serviceName) {
    return serviceName in _services ? _services[serviceName] : null;
  }

  /**
   * Register a business service.
   */
  void registerService(string serviceName, IBusinessService service) {
    _services[serviceName] = service;
  }

  /**
   * Check if a service is registered.
   */
  bool hasService(string serviceName) {
    return (serviceName in _services) !is null;
  }

  /**
   * Remove a registered service.
   */
  bool removeService(string serviceName) {
    if (hasService(serviceName)) {
      _services.remove(serviceName);
      return true;
    }
    return false;
  }

  /**
   * Get all registered service names.
   */
  string[] serviceNames() {
    import std.array : array;
    return _services.keys.array;
  }

  /**
   * Clear all registered services.
   */
  void clear() {
    _services.clear();
  }
}

/**
 * Base Business Delegate implementation.
 * Provides basic delegation to business services through a lookup service.
 */
class BusinessDelegate : IBusinessDelegate {
  protected IBusinessLookup _lookupService;
  protected string _serviceType;

  /**
   * Constructor.
   * Params:
   *   lookupService = The lookup service for finding business services
   *   serviceType = The type of service this delegate works with
   */
  this(IBusinessLookup lookupService, string serviceType) {
    _lookupService = lookupService;
    _serviceType = serviceType;
  }

  /**
   * Execute a business operation through the delegate.
   */
  string doTask() {
    auto service = _lookupService.getBusinessService(_serviceType);
    if (service is null) {
      return "Error: Service '" ~ _serviceType ~ "' not found";
    }
    return service.execute();
  }

  /**
   * Get the service type this delegate works with.
   */
  string serviceType() {
    return _serviceType;
  }
}

/**
 * Generic Business Delegate implementation.
 */
class GenericBusinessDelegate(TInput, TOutput) : IGenericBusinessDelegate!(TInput, TOutput) {
  private IGenericBusinessService!(TInput, TOutput) _service;
  private string _serviceType;

  /**
   * Constructor.
   * Params:
   *   service = The business service to delegate to
   *   serviceType = The type of service
   */
  this(IGenericBusinessService!(TInput, TOutput) service, string serviceType) {
    _service = service;
    _serviceType = serviceType;
  }

  /**
   * Execute a business operation with input data.
   */
  TOutput doTask(TInput input) {
    return _service.execute(input);
  }

  /**
   * Get the service type this delegate works with.
   */
  string serviceType() {
    return _serviceType;
  }
}

/**
 * Cacheable Business Delegate.
 * Adds caching layer to business delegate operations.
 */
class CacheableBusinessDelegate : BusinessDelegate, ICacheableBusinessDelegate {
  private string[string] _cache;
  private bool _cacheEnabled;
  private string _lastInput;

  /**
   * Constructor.
   */
  this(IBusinessLookup lookupService, string serviceType) {
    super(lookupService, serviceType);
    _cacheEnabled = true;
  }

  /**
   * Execute a business operation with caching.
   */
  override string doTask() {
    // Create cache key based on service type
    string cacheKey = _serviceType;

    if (_cacheEnabled && cacheKey in _cache) {
      return _cache[cacheKey];
    }

    string result = super.doTask();

    if (_cacheEnabled) {
      _cache[cacheKey] = result;
    }

    return result;
  }

  /**
   * Enable caching.
   */
  void enableCache() {
    _cacheEnabled = true;
  }

  /**
   * Disable caching.
   */
  void disableCache() {
    _cacheEnabled = false;
  }

  /**
   * Clear the cache.
   */
  void clearCache() {
    _cache.clear();
  }

  /**
   * Check if caching is enabled.
   */
  bool isCacheEnabled() {
    return _cacheEnabled;
  }
}

/**
 * Retryable Business Delegate.
 * Automatically retries failed operations.
 */
class RetryableBusinessDelegate : BusinessDelegate, IRetryableBusinessDelegate {
  private int _maxRetries;
  private int _retryCount;

  /**
   * Constructor.
   */
  this(IBusinessLookup lookupService, string serviceType, int maxRetries = 3) {
    super(lookupService, serviceType);
    _maxRetries = maxRetries;
    _retryCount = 0;
  }

  /**
   * Execute with retry logic.
   */
  override string doTask() {
    _retryCount = 0;
    string result;

    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        result = super.doTask();
        
        // Check if result indicates an error
        if (result.length > 6 && result[0..6] == "Error:") {
          _retryCount++;
          if (attempt < _maxRetries) {
            continue; // Retry
          }
        }
        break; // Success or max retries reached
      } catch (Exception e) {
        _retryCount++;
        if (attempt >= _maxRetries) {
          return "Error: Max retries exceeded - " ~ e.msg;
        }
      }
    }

    return result;
  }

  /**
   * Set maximum retry attempts.
   */
  void setMaxRetries(int attempts) {
    _maxRetries = attempts;
  }

  /**
   * Get current retry count.
   */
  int retryCount() {
    return _retryCount;
  }
}

/**
 * Logging Business Delegate.
 * Adds logging capabilities to delegate operations.
 */
class LoggingBusinessDelegate : BusinessDelegate {
  private string[] _logs;
  private bool _loggingEnabled;

  /**
   * Constructor.
   */
  this(IBusinessLookup lookupService, string serviceType) {
    super(lookupService, serviceType);
    _loggingEnabled = true;
  }

  /**
   * Execute with logging.
   */
  override string doTask() {
    if (_loggingEnabled) {
      import std.datetime : Clock;
      _logs ~= "[" ~ Clock.currTime().toISOExtString() ~ "] Executing service: " ~ _serviceType;
    }

    string result = super.doTask();

    if (_loggingEnabled) {
      import std.datetime : Clock;
      _logs ~= "[" ~ Clock.currTime().toISOExtString() ~ "] Result: " ~ result;
    }

    return result;
  }

  /**
   * Get all logs.
   */
  string[] logs() {
    return _logs;
  }

  /**
   * Clear logs.
   */
  void clearLogs() {
    _logs = [];
  }

  /**
   * Enable or disable logging.
   */
  void setLoggingEnabled(bool enabled) {
    _loggingEnabled = enabled;
  }
}

/**
 * Composite Business Delegate.
 * Delegates to multiple services and combines results.
 */
class CompositeBusinessDelegate : IBusinessDelegate {
  private IBusinessDelegate[] _delegates;
  private string _serviceType;

  /**
   * Constructor.
   */
  this(string serviceType) {
    _serviceType = serviceType;
  }

  /**
   * Add a delegate to the composite.
   */
  void addDelegate(IBusinessDelegate delegate_) {
    _delegates ~= delegate_;
  }

  /**
   * Execute all delegates and combine results.
   */
  string doTask() {
    import std.array : join;
    string[] results;

    foreach (delegate_; _delegates) {
      results ~= delegate_.doTask();
    }

    return results.join(" | ");
  }

  /**
   * Get the service type.
   */
  string serviceType() {
    return _serviceType;
  }

  /**
   * Get number of delegates.
   */
  size_t delegateCount() {
    return _delegates.length;
  }
}

// Unit Tests

version(unittest) {
  // Test business service implementation
  class TestBusinessService : IBusinessService {
    private string _name;
    private string _result;

    this(string name, string result) @safe {
      _name = name;
      _result = result;
    }

    string execute() {
      return _result;
    }

    string serviceName() {
      return _name;
    }
  }

  // Test generic business service
  class CalculatorService : IGenericBusinessService!(int[], int) {
    string execute() {
      return "Processed";
    }

    int execute(int[] numbers) {
      int sum = 0;
      foreach (num; numbers) {
        sum += num;
      }
      return sum;
    }

    string serviceName() {
      return "Calculator";
    }
  }
}

@safe unittest {
  // Test Business Lookup
  auto lookup = new BusinessLookup();
  auto service1 = new TestBusinessService("Service1", "Result from Service1");
  auto service2 = new TestBusinessService("Service2", "Result from Service2");

  // Register services
  lookup.registerService("Service1", service1);
  lookup.registerService("Service2", service2);

  assert(lookup.hasService("Service1"));
  assert(lookup.hasService("Service2"));
  assert(!lookup.hasService("Service3"));

  // Get services
  auto retrieved = lookup.getBusinessService("Service1");
  assert(retrieved !is null);
  assert(retrieved.serviceName() == "Service1");

  // Remove service
  assert(lookup.removeService("Service2"));
  assert(!lookup.hasService("Service2"));
}

@safe unittest {
  // Test Business Delegate
  auto lookup = new BusinessLookup();
  auto service = new TestBusinessService("TestService", "Test Result");
  lookup.registerService("TestService", service);

  auto delegate_ = new BusinessDelegate(lookup, "TestService");
  string result = delegate_.doTask();

  assert(result == "Test Result");
  assert(delegate_.serviceType() == "TestService");
}

@safe unittest {
  // Test Cacheable Business Delegate
  auto lookup = new BusinessLookup();
  auto service = new TestBusinessService("CacheTest", "Cached Result");
  lookup.registerService("CacheTest", service);

  auto cacheableDelegate = new CacheableBusinessDelegate(lookup, "CacheTest");

  // First call - not cached
  assert(cacheableDelegate.isCacheEnabled());
  string result1 = cacheableDelegate.doTask();
  assert(result1 == "Cached Result");

  // Second call - should be cached
  string result2 = cacheableDelegate.doTask();
  assert(result2 == "Cached Result");

  // Disable cache
  cacheableDelegate.disableCache();
  assert(!cacheableDelegate.isCacheEnabled());

  // Clear cache
  cacheableDelegate.clearCache();
  cacheableDelegate.enableCache();
}

@safe unittest {
  // Test Retryable Business Delegate
  auto lookup = new BusinessLookup();
  auto service = new TestBusinessService("RetryTest", "Success");
  lookup.registerService("RetryTest", service);

  auto retryDelegate = new RetryableBusinessDelegate(lookup, "RetryTest", 3);
  retryDelegate.setMaxRetries(5);

  string result = retryDelegate.doTask();
  assert(result == "Success");
  assert(retryDelegate.retryCount() == 0); // No retries needed for success
}

@safe unittest {
  // Test Logging Business Delegate
  auto lookup = new BusinessLookup();
  auto service = new TestBusinessService("LogTest", "Logged Result");
  lookup.registerService("LogTest", service);

  auto loggingDelegate = new LoggingBusinessDelegate(lookup, "LogTest");
  string result = loggingDelegate.doTask();

  assert(result == "Logged Result");
  assert(loggingDelegate.logs().length > 0);

  loggingDelegate.clearLogs();
  assert(loggingDelegate.logs().length == 0);

  loggingDelegate.setLoggingEnabled(false);
  loggingDelegate.doTask();
  assert(loggingDelegate.logs().length == 0); // No new logs
}

@safe unittest {
  // Test Composite Business Delegate
  auto lookup = new BusinessLookup();
  auto service1 = new TestBusinessService("S1", "Result1");
  auto service2 = new TestBusinessService("S2", "Result2");
  auto service3 = new TestBusinessService("S3", "Result3");

  lookup.registerService("S1", service1);
  lookup.registerService("S2", service2);
  lookup.registerService("S3", service3);

  auto composite = new CompositeBusinessDelegate("Composite");
  composite.addDelegate(new BusinessDelegate(lookup, "S1"));
  composite.addDelegate(new BusinessDelegate(lookup, "S2"));
  composite.addDelegate(new BusinessDelegate(lookup, "S3"));

  assert(composite.delegateCount() == 3);

  string result = composite.doTask();
  assert(result == "Result1 | Result2 | Result3");
}

@safe unittest {
  // Test non-existent service
  auto lookup = new BusinessLookup();
  auto delegate_ = new BusinessDelegate(lookup, "NonExistent");

  string result = delegate_.doTask();
  assert(result.length > 6);
  assert(result[0..6] == "Error:");
}

@safe unittest {
  // Test Generic Business Delegate
  auto calculator = new CalculatorService();
  auto genericDelegate = new GenericBusinessDelegate!(int[], int)(calculator, "Calculator");

  assert(genericDelegate.serviceType() == "Calculator");
  int result = genericDelegate.doTask([1, 2, 3, 4, 5]);
  assert(result == 15);
}
