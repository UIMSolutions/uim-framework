/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.pools.pooled;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * RAII wrapper for pooled objects.
 * Automatically returns the object to the pool when destroyed.
 */
struct PooledObject(T) {
  private {
    T _object;
    IObjectPool!T _pool;
    bool _released;
  }

  @disable this();
  @disable this(this); // Disable copying

  /**
   * Constructor.
   * Params:
   *   obj = The pooled object
   *   pool = The pool to return the object to
   */
  this(T obj, IObjectPool!T pool) {
    _object = obj;
    _pool = pool;
    _released = false;
  }

  /**
   * Destructor - automatically returns object to pool.
   */
  ~this() {
    release();
  }

  /**
   * Get the underlying object.
   * Returns: The pooled object
   */
  T get() {
    return _object;
  }

  /**
   * Access the underlying object.
   * Returns: The pooled object
   */
  T opUnary(string op)() if (op == "*") {
    return _object;
  }

  /**
   * Forward property/method access to the underlying object.
   */
  alias get this;

  /**
   * Manually release the object back to the pool.
   */
  void release() {
    if (!_released && _object !is null && _pool !is null) {
      _pool.release(_object);
      _released = true;
      _object = null;
    }
  }

  /**
   * Check if the object has been released.
   */
  bool isReleased() const {
    return _released;
  }
}

/**
 * Helper function to acquire a pooled object with RAII semantics.
 * Params:
 *   pool = The object pool to acquire from
 * Returns: A PooledObject wrapper
 */
PooledObject!T acquirePooled(T)(IObjectPool!T pool) {
  return PooledObject!T(pool.acquire(), pool);
}

