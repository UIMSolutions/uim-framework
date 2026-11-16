module uim.oop.patterns.proxies.classes.logging;

import uim.oop;

mixin(ShowModule!());

@safe:

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
  this(IProxySubject realSubject) {
    _realSubject = realSubject;
    _log = [];
  }

  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() {
    return _realSubject;
  }

  /**
   * Get the access log.
   */
  string[] getLog() {
    return _log;
  }

  /**
   * Clear the log.
   */
  void clearLog() {
    _log = [];
  }

  /**
   * Execute with logging.
   */
  string execute() {
    import std.datetime : Clock;
    auto timestamp = Clock.currTime().toISOExtString();
    _log ~= "Access at " ~ timestamp;
    auto result = _realSubject.execute();
    _log ~= "Result: " ~ result;
    return result;
  }
}