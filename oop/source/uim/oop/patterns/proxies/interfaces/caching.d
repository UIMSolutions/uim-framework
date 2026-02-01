/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
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
