/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.threadsafe;

import uim.oop;
import core.sync.mutex;

mixin(ShowModule!());

@safe:
/**
 * Thread-safe object pool implementation.
 * Uses mutex to ensure safe concurrent access.
 */
class ThreadSafeObjectPool(T) : IObjectPool!T, IPoolStatistics {
  private {
    ObjectPool!T _pool;
    Mutex _mutex;
  }

  /**
   * Constructor.
   * Params:
   *   factory = Function to create new instances
   *   initialCapacity = Initial capacity
   *   maxCapacity = Maximum capacity
   */
  this(T delegate() @safe factory, size_t initialCapacity = 10, size_t maxCapacity = 100) {
    _pool = new ObjectPool!T(factory, initialCapacity, maxCapacity);
    _mutex = new Mutex();
  }

  /**
   * Thread-safe acquire operation.
   */
  T acquire() @trusted {
    synchronized (_mutex) {
      return _pool.acquire();
    }
  }

  /**
   * Thread-safe release operation.
   */
  void release(T obj) @trusted {
    synchronized (_mutex) {
      _pool.release(obj);
    }
  }

  /**
   * Thread-safe available count.
   */
  size_t available() @trusted {
    synchronized (_mutex) {
      return _pool.available();
    }
  }

  /**
   * Thread-safe total count.
   */
  size_t totalCount() @trusted {
    synchronized (_mutex) {
      return _pool.totalCount();
    }
  }

  /**
   * Thread-safe clear operation.
   */
  void clear() @trusted {
    synchronized (_mutex) {
      _pool.clear();
    }
  }

  /**
   * Get capacity.
   */
  size_t capacity() @trusted {
    synchronized (_mutex) {
      return _pool.capacity();
    }
  }

  /**
   * Set capacity.
   */
  void capacity(size_t newCapacity) @trusted {
    synchronized (_mutex) {
      _pool.capacity(newCapacity);
    }
  }

  // IPoolStatistics implementation
  ulong acquireCount() @trusted {
    synchronized (_mutex) {
      return _pool.acquireCount();
    }
  }

  ulong releaseCount() @trusted {
    synchronized (_mutex) {
      return _pool.releaseCount();
    }
  }

  ulong createCount() @trusted {
    synchronized (_mutex) {
      return _pool.createCount();
    }
  }

  size_t peakAcquired() @trusted {
    synchronized (_mutex) {
      return _pool.peakAcquired();
    }
  }

  void resetStatistics() @trusted {
    synchronized (_mutex) {
      _pool.resetStatistics();
    }
  }
}

/**
 * Create a thread-safe object pool.
 */
ThreadSafeObjectPool!T createThreadSafePool(T)(T delegate() @safe factory,
                                                size_t initialCapacity = 10,
                                                size_t maxCapacity = 100) {
  return new ThreadSafeObjectPool!T(factory, initialCapacity, maxCapacity);
}

/**
 * Thread-safe scoped object pool.
 */
class ThreadSafeScopedPool(T) : IScopedObjectPool!T {
  private ThreadSafeObjectPool!T _pool;

  this(T delegate() @safe factory, size_t initialCapacity = 10, size_t maxCapacity = 100) {
    _pool = new ThreadSafeObjectPool!T(factory, initialCapacity, maxCapacity);
  }

  /**
   * Acquire a scoped object.
   */
  PooledObject!T acquireScoped() @trusted {
    return PooledObject!T(acquire(), this);
  }

  // Delegate to underlying pool
  T acquire() @trusted { return _pool.acquire(); }
  void release(T obj) @trusted { _pool.release(obj); }
  size_t available() @trusted { return _pool.available(); }
  size_t totalCount() @trusted { return _pool.totalCount(); }
  void clear() @trusted { _pool.clear(); }
  size_t capacity() @trusted { return _pool.capacity(); }
  void capacity(size_t newCapacity) @trusted { _pool.capacity(newCapacity); }

  IPoolStatistics statistics() @trusted {
    return cast(IPoolStatistics)_pool;
  }
}

/**
 * Create a thread-safe scoped pool.
 */
ThreadSafeScopedPool!T createThreadSafeScopedPool(T)(T delegate() @safe factory,
                                                      size_t initialCapacity = 10,
                                                      size_t maxCapacity = 100) {
  return new ThreadSafeScopedPool!T(factory, initialCapacity, maxCapacity);
}

// Unit tests
unittest {
  import core.thread;
  import std.stdio;

  class TestObject {
    int value;
    this() { value = 0; }
  }

  auto pool = createThreadSafePool(() => new TestObject(), 5, 20);
  
  // Basic single-threaded test
  auto obj1 = pool.acquire();
  assert(obj1 !is null);
  assert(pool.available() == 0);
  
  pool.release(obj1);
  assert(pool.available() == 1);
}

unittest {
  class TestObject {
    int value;
    this() { value = 0; }
  }

  auto pool = createThreadSafePool(() => new TestObject(), 10, 50);
  
  // Test statistics
  auto obj = pool.acquire();
  assert(pool.acquireCount() == 1);
  assert(pool.createCount() == 1);
  
  pool.release(obj);
  assert(pool.releaseCount() == 1);
  
  auto obj2 = pool.acquire();
  assert(pool.createCount() == 1); // Reused 
}

unittest {
  class TestObject {
    int value;
    this() { value = 0; }
  }

  auto scopedPool = createThreadSafeScopedPool(() => new TestObject(), 5, 15);
  
  {
    auto obj = scopedPool.acquireScoped();
    obj.value = 42;
    assert(scopedPool.available() == 0);
  }
  
  assert(scopedPool.available() == 1);
}
