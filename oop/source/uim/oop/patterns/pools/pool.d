/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.pool;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Basic object pool implementation.
 * Manages a pool of reusable objects to reduce allocation overhead.
 */
class ObjectPool(T) : IObjectPool!T, IPoolStatistics {
  protected {
    T[] _availableObjects;
    size_t _totalCreated;
    T delegate() @safe _factory;

    // Statistics
    ulong _acquireCount;
    ulong _releaseCount;
    ulong _createCount;
    size_t _peakAcquired;
    size_t _currentAcquired;
  }

  /**
   * Constructor with factory function.
   * Params:
   *   factory = Function to create new instances
   *   initialCapacity = Initial capacity of the pool
   *   maxCapacity = Maximum capacity of the pool (0 for unlimited)
   */
  this(T delegate() @safe factory, size_t initialCapacity = 10, size_t maxCapacity = 100) {
    _factory = factory;
    _capacity = maxCapacity;
    _availableObjects.reserve(initialCapacity);
  }

  /**
   * Acquire an object from the pool.
   * Returns: An object of type T
   */
  T acquire() {
    // Update statistics
    _acquireCount++;
    _currentAcquired++;

    // Update peak acquired count
    if (_currentAcquired > _peakAcquired) {
      _peakAcquired = _currentAcquired;
    }

    // Return an available object if possible
    if (_availableObjects.length > 0) {
      auto obj = _availableObjects[$ - 1];
      _availableObjects = _availableObjects[0 .. $ - 1];
      return obj;
    }

    _createCount++;
    _totalCreated++;

    // Create a new object using the factory
    return _factory();
  }

  /**
   * Release an object back to the pool.
   * Params:
   *   obj = The object to return to the pool
   */
  void release(T obj) {
    if (obj is null) {
      return;
    }

    _releaseCount++;
    _currentAcquired--;

    // Reset poolable objects
    static if (is(T : IPoolable)) {
      if (!obj.isValidForPool()) {
        return;
      }
      obj.reset();
    }

    // Don't exceed capacity
    if (_capacity > 0 && _availableObjects.length >= _capacity) {
      return;
    }

    _availableObjects ~= obj;
  }

  /**
   * Get the number of available objects in the pool.
   */
  size_t available() {
    return _availableObjects.length;
  }

  // #region Total Count
  /**
   * Get the total number of objects created.
   */
  size_t totalCount() {
    return _totalCreated;
  }
  // #endregion Total Count

  /**
   * Clear all objects from the pool.
   */
  void clear() {
    _availableObjects.length = 0;
    _totalCreated = 0;
    _currentAcquired = 0;
  }

  // #region Capacity
  protected size_t _capacity;
  /**
   * Get the maximum capacity of the pool.
   */
  size_t capacity() {
    return _capacity;
  }

  /**
   * Set the maximum capacity of the pool.
   */
  void capacity(size_t newCapacity) {
    _capacity = newCapacity;

    if (_availableObjects.length > _capacity) { // 
      // Trim excess objects
      _availableObjects = _availableObjects[0 .. _capacity];
    }
  }
  // #endregion Capacity

  // #region Statistics
  // IPoolStatistics implementation
  
  ulong acquireCount() {
    return _acquireCount;
  }

  ulong releaseCount() {
    return _releaseCount;
  }

  ulong createCount() {
    return _createCount;
  }

  size_t peakAcquired() {
    return _peakAcquired;
  }

  void resetStatistics() {
    _acquireCount = 0;
    _releaseCount = 0;
    _createCount = 0;
    _peakAcquired = 0;
  }
}
// #endregion Statistics

/**
 * Convenience function to create an object pool.
 * Params:
 *   factory = Function to create new instances
 *   initialCapacity = Initial capacity
 *   maxCapacity = Maximum capacity
 * Returns: A new ObjectPool instance
 */
ObjectPool!T createObjectPool(T)(T delegate() @safe factory,
  size_t initialCapacity = 10,
  size_t maxCapacity = 100) {
  return new ObjectPool!T(factory, initialCapacity, maxCapacity);
}

// Unit tests
unittest {
  import std.stdio;

  class TestObject {
    int value;
    this(int v = 0) {
      value = v;
    }
  }

  // Test basic pool operations
  auto pool = createObjectPool(() => new TestObject(42), 5, 20);

  auto obj1 = pool.acquire();
  assert(obj1 !is null);
  assert(obj1.value == 42);
  assert(pool.available() == 0);

  pool.release(obj1);
  assert(pool.available() == 1);

  auto obj2 = pool.acquire();
  assert(obj2 is obj1); // Should get the same object back
  assert(pool.available() == 0);
}

unittest {
  class PoolableObject : IPoolable {
    int value;
    bool valid = true;

    this() {
      value = 0;
    }

    void reset() {
      value = 0;
    }

    bool isValidForPool() {
      return valid;
    }
  }

  auto pool = createObjectPool(() => new PoolableObject(), 5, 10);

  auto obj = pool.acquire();
  obj.value = 100;
  assert(obj.value == 100);

  pool.release(obj);
  auto obj2 = pool.acquire();
  assert(obj2.value == 0); // Should be reset
}

unittest {
  class TestObject {
    this() {
    }
  }

  auto pool = createObjectPool(() => new TestObject(), 2, 5);

  // Test statistics
  assert(pool.acquireCount() == 0);
  assert(pool.createCount() == 0);

  auto obj1 = pool.acquire();
  assert(pool.acquireCount() == 1);
  assert(pool.createCount() == 1);

  pool.release(obj1);
  assert(pool.releaseCount() == 1);

  auto obj2 = pool.acquire();
  assert(pool.acquireCount() == 2);
  assert(pool.createCount() == 1); // Reused existing object
}
