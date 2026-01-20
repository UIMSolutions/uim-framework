/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for object pools.
 * Provides a contract for managing reusable object instances.
 */
interface IObjectPool(T) {
  /**
   * Acquire an object from the pool.
   * Creates a new instance if the pool is empty.
   * Returns: An object of type T
   */
  T acquire();

  /**
   * Release an object back to the pool.
   * Params:
   *   obj = The object to return to the pool
   */
  void release(T obj);

  /**
   * Get the number of available objects in the pool.
   * Returns: The count of available objects
   */
  size_t available();

  /**
   * Get the total number of objects managed by the pool.
   * Returns: The total count including both available and acquired objects
   */
  size_t totalCount();

  /**
   * Clear all objects from the pool.
   */
  void clear();

  /**
   * Get the maximum capacity of the pool.
   * Returns: The maximum number of objects the pool can hold
   */
  size_t capacity();

  /**
   * Set the maximum capacity of the pool.
   * Params:
   *   newCapacity = The new maximum capacity
   */
  void capacity(size_t newCapacity);
}

interface IScopedObjectPool(T) : IObjectPool!T {
  /**
   * Acquire an object wrapped in a RAII wrapper.
   * Returns: A PooledObject that automatically returns to the pool
   */
  PooledObject!T acquireScoped();
}

/**
 * Interface for objects that can be reset when returned to a pool.
 */
interface IPoolable {
  /**
   * Reset the object to its initial state.
   * Called when the object is returned to the pool.
   */
  void reset();

  /**
   * Check if the object is in a valid state for pooling.
   * Returns: true if the object can be safely returned to the pool
   */
  bool isValidForPool();
}

/**
 * Interface for pool statistics and monitoring.
 */
interface IPoolStatistics {
  /**
   * Get the number of times objects were acquired.
   * Returns: Total acquisition count
   */
  ulong acquireCount();

  /**
   * Get the number of times objects were released.
   * Returns: Total release count
   */
  ulong releaseCount();

  /**
   * Get the number of times new objects were created.
   * Returns: Total creation count
   */
  ulong createCount();

  /**
   * Get the peak number of objects acquired at once.
   * Returns: Peak acquisition count
   */
  size_t peakAcquired();

  /**
   * Reset all statistics.
   */
  void resetStatistics();
}
