module uim.oop.patterns.proxies.virtual;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Virtual Proxy for lazy initialization.
 * Creates the real subject only when needed.
 */
class VirtualProxy : IVirtualProxy {
  private IProxySubject _realSubject;
  private IProxySubject delegate() @safe _factory;
  private bool _initialized;

  /**
   * Constructor with factory function.
   */
  this(IProxySubject delegate() @safe factory) @safe {
    _factory = factory;
    _initialized = false;
  }

  /**
   * Check if real subject has been created.
   */
  bool isInitialized() @safe {
    return _initialized;
  }

  /**
   * Get the real subject (lazy initialization).
   */
  IProxySubject getRealSubject() @safe {
    if (!_initialized) {
      _realSubject = _factory();
      _initialized = true;
    }
    return _realSubject;
  }

  /**
   * Execute with lazy initialization.
   */
  string execute() @safe {
    return getRealSubject().execute();
  }
}