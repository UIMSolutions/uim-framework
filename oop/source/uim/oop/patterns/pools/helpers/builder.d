/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.helpers.builder;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Pool builder for fluent configuration.
 */
class PoolBuilder(T) {
  private {
    T delegate() @safe _factory;
    PoolConfig _config;
  }

  this(T delegate() @safe factory) {
    _factory = factory;
  }

  /**
   * Set initial capacity.
   */
  PoolBuilder!T initialCapacity(size_t capacity) {
    _config.initialCapacity = capacity;
    return this;
  }

  /**
   * Set maximum capacity.
   */
  PoolBuilder!T maxCapacity(size_t capacity) {
    _config.maxCapacity = capacity;
    return this;
  }

  /**
   * Enable thread-safe mode.
   */
  PoolBuilder!T threadSafe(bool enabled = true) {
    _config.threadSafe = enabled;
    return this;
  }

  /**
   * Enable statistics tracking.
   */
  PoolBuilder!T withStatistics(bool enabled = true) {
    _config.enableStatistics = enabled;
    return this;
  }

  /**
   * Build the object pool.
   */
  IObjectPool!T build() {
    if (_config.threadSafe) {
      return new ThreadSafeObjectPool!T(_factory, _config.initialCapacity, _config.maxCapacity);
    }
    return new ObjectPool!T(_factory, _config.initialCapacity, _config.maxCapacity);
  }

  /**
   * Build a scoped pool.
   */
  IScopedObjectPool!T  buildScoped() {
    if (_config.threadSafe) {
      return new ThreadSafeScopedPool!T(_factory, _config.initialCapacity, _config.maxCapacity);
    }
    return new ScopedObjectPool!T(_factory, _config.initialCapacity, _config.maxCapacity);
  }
}

/**
 * Create a pool builder.
 */
PoolBuilder!T poolBuilder(T)(T delegate() @safe factory) {
  return new PoolBuilder!T(factory);
}