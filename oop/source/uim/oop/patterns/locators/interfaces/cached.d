/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.locators.interfaces.cached;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for cached service locator.
 */
interface ICachedServiceLocator : IServiceLocator {
  /**
   * Enable or disable caching.
   * Params:
   *   enabled = true to enable caching, false to disable
   */
  void setCacheEnabled(bool enabled) @safe;

  /**
   * Check if caching is enabled.
   * Returns: true if caching is enabled, false otherwise
   */
  bool isCacheEnabled() @safe;

  /**
   * Clear the service cache.
   */
  void clearCache() @safe;
}
