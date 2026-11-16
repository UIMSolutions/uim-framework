/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.interfaces.cacheable;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Cacheable DAO interface.
 */
interface ICacheableDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Enable caching.
   */
  void enableCache();

  /**
   * Disable caching.
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