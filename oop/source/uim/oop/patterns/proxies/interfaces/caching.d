module uim.oop.patterns.proxies.interfaces.caching;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Interface for caching proxy.
 */
interface ICachingProxy : IProxy {
  /**
   * Clear the cache.
   */
  void clearCache() @safe;

  /**
   * Check if result is cached.
   */
  bool isCached() @safe;
}