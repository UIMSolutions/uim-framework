/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.helpers.registry;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Global pool registry for sharing pools across the application.
 */
class PoolRegistry {
  private static {
    Object[string] _pools;
  }

  /**
   * Register a pool with a name.
   */
  static void register(T)(string name, IObjectPool!T pool) {
    synchronized {
      _pools[name] = cast(Object)pool;
    }
  }

  /**
   * Get a registered pool by name.
   */
  static IObjectPool!T get(T)(string name) {
    synchronized {
      if (auto pool = name in _pools) {
        return cast(IObjectPool!T)(*pool);
      }
      return null;
    }
  }

  /**
   * Unregister a pool.
   */
  static void unregister(string name) {
    synchronized {
      _pools.remove(name);
    }
  }

  /**
   * Check if a pool is registered.
   */
  static bool has(string name) {
    synchronized {
      return (name in _pools) !is null;
    }
  }

  /**
   * Clear all registered pools.
   */
  static void clear() {
    synchronized {
      _pools.clear();
    }
  }
}