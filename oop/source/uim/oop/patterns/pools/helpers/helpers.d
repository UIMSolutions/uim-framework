/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.helpers.helpers;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Pool configuration structure.
 */
struct PoolConfig {
  size_t initialCapacity = 10;
  size_t maxCapacity = 100;
  bool threadSafe = false;
  bool enableStatistics = true;
}


/**
 * Pooled array wrapper for frequently allocated arrays.
 */
class ArrayPool(T) {
  private ObjectPool!(T[]) _pool;

  this(size_t arraySize, size_t initialCapacity = 10, size_t maxCapacity = 50) {
    _pool = new ObjectPool!(T[])(() {
      return new T[arraySize];
    }, initialCapacity, maxCapacity);
  }

  /**
   * Acquire an array from the pool.
   */
  T[] acquire() {
    return _pool.acquire();
  }

  /**
   * Release an array back to the pool.
   */
  void release(T[] array) {
    // Clear array contents before returning to pool
    array[] = T.init;
    _pool.release(array);
  }

  /**
   * Get available arrays count.
   */
  size_t available() {
    return _pool.available();
  }
}

/**
 * Create an array pool.
 */
ArrayPool!T createArrayPool(T)(size_t arraySize, size_t initialCapacity = 10, size_t maxCapacity = 50) {
  return new ArrayPool!T(arraySize, initialCapacity, maxCapacity);
}

// Unit tests
unittest {
  class TestObject {
    int value;
    this() { value = 42; }
  }

  auto pool = poolBuilder(() => new TestObject())
    .initialCapacity(5)
    .maxCapacity(20)
    .build();

  assert(pool !is null);
  auto obj = pool.acquire();
  assert(obj.value == 42);
  pool.release(obj);
}

unittest {
  class TestObject {
    this() {}
  }

  auto pool = poolBuilder(() => new TestObject())
    .threadSafe(true)
    .initialCapacity(10)
    .maxCapacity(50)
    .build();

  assert(pool !is null);
  auto obj = pool.acquire();
  pool.release(obj);
}

unittest {
  class TestObject {
    this() {}
  }

  auto pool = createObjectPool(() => new TestObject(), 5, 10);
  
  PoolRegistry.register("testPool", pool);
  assert(PoolRegistry.has("testPool"));
  
  auto retrieved = PoolRegistry.get!TestObject("testPool");
  assert(retrieved !is null);
  
  PoolRegistry.unregister("testPool");
  assert(!PoolRegistry.has("testPool"));
}

unittest {
  auto arrayPool = createArrayPool!int(10, 5, 20);
  
  auto arr1 = arrayPool.acquire();
  assert(arr1.length == 10);
  
  arr1[0] = 100;
  arrayPool.release(arr1);
  assert(arrayPool.available() == 1);
  
  auto arr2 = arrayPool.acquire();
  assert(arr2[0] == 0); // Should be cleared
}

unittest {
  class TestObject {
    this() {}
  }

  auto scopedPool = poolBuilder(() => new TestObject())
    .initialCapacity(3)
    .maxCapacity(10)
    .buildScoped();

  {
    auto obj = scopedPool.acquireScoped();
    assert(scopedPool.available() == 0);
  }
  
  assert(scopedPool.available() == 1);
}
