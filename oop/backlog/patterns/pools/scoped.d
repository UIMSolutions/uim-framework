module uim.oop.patterns.pools.scoped;

import uim.oop;
import core.sync.mutex;

mixin(ShowModule!());

@safe:
/**
 * Scoped object pool implementation.
 * Provides RAII-style pooled objects that automatically return to the pool.
 */

 /**
 * Scoped object pool that automatically manages object lifecycle.
 */
class ScopedObjectPool(T) : IScopedObjectPool!T {
  private ObjectPool!T _pool;

  this(T delegate() @safe factory, size_t initialCapacity = 10, size_t maxCapacity = 100) {
    _pool = new ObjectPool!T(factory, initialCapacity, maxCapacity);
  }

  /**
   * Acquire an object wrapped in a RAII wrapper.
   */
  PooledObject!T acquireScoped() {
    return PooledObject!T(acquire(), this);
  }

  // Delegate to underlying pool
  T acquire() { return _pool.acquire(); }
  void release(T obj) { _pool.release(obj); }
  size_t available() { return _pool.available(); }
  size_t totalCount() { return _pool.totalCount(); }
  void clear() { _pool.clear(); }
  size_t capacity() { return _pool.capacity(); }
  void capacity(size_t newCapacity) { _pool.capacity(newCapacity); }

  /**
   * Get statistics if available.
   */
  IPoolStatistics statistics() {
    return cast(IPoolStatistics)_pool;
  }
}


/**
 * Create a scoped object pool.
 */
ScopedObjectPool!T createScopedPool(T)(T delegate() @safe factory,
                                        size_t initialCapacity = 10,
                                        size_t maxCapacity = 100) {
  return new ScopedObjectPool!T(factory, initialCapacity, maxCapacity);
}

// Unit tests
unittest {
  class TestObject {
    int value;
    bool destroyed;
    this() { value = 0; destroyed = false; }
  }

  auto pool = createObjectPool(() => new TestObject(), 5, 10);
  
  {
    auto pooled = acquirePooled(pool);
    assert(pool.available() == 0);
    pooled.value = 42;
    assert(pooled.value == 42);
  } // pooled should be automatically released here
  
  assert(pool.available() == 1);
}

unittest {
  class TestObject {
    int value;
    this() { value = 100; }
  }

  auto scopedPool = createScopedPool(() => new TestObject(), 3, 10);
  
  {
    auto obj1 = scopedPool.acquireScoped();
    assert(obj1.value == 100);
    assert(scopedPool.available() == 0);
  }
  
  assert(scopedPool.available() == 1);
  
  // Test manual release
  auto obj2 = scopedPool.acquireScoped();
  assert(!obj2.isReleased());
  obj2.release();
  assert(obj2.isReleased());
}

unittest {
  class PoolableTest : IPoolable {
    int value;
    this() { value = 0; }
    void reset() { value = 0; }
    bool isValidForPool() { return true; }
  }

  auto pool = createScopedPool(() => new PoolableTest(), 2, 5);
  
  {
    auto obj = pool.acquireScoped();
    obj.value = 999;
  }
  
  auto obj2 = pool.acquireScoped();
  assert(obj2.value == 0); // Should be reset
}
