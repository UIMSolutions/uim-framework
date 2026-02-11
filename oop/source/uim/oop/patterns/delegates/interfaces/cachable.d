module uim.oop.patterns.delegates.interfaces.cachable;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Cacheable Business Delegate interface.
 * Adds caching capabilities to business delegate operations.
 */
interface ICacheableBusinessDelegate : IBusinessDelegate {
  /**
   * Enable caching for this delegate.
   */
  void enableCache();

  /**
   * Disable caching for this delegate.
   */
  void disableCache();

  /**
   * Clear the cache.
   */
  void clearCache();

  /**
   * Check if caching is enabled.
   * Returns: true if caching is enabled
   */
  bool isCacheEnabled();
}
