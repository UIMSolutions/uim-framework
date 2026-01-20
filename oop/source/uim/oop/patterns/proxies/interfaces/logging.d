module uim.oop.patterns.proxies.interfaces.logging;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Interface for logging proxy.
 */
interface ILoggingProxy : IProxy {
  /**
   * Get the access log.
   */
  string[] getLog() @safe;

  /**
   * Clear the log.
   */
  void clearLog() @safe;
}