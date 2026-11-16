module uim.oop.patterns.proxies.interfaces.virtual;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Interface for virtual proxy (lazy initialization).
 */
interface IVirtualProxy : IProxy {
  /**
   * Check if real subject has been created.
   */
  bool isInitialized() @safe;
}
