/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.classes.base;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base abstract DAO implementation.
 * Provides common functionality for data access operations.
 */
abstract class BaseDAO(T, ID) : IQueryableDAO!(T, ID) {
  /**
   * Find an entity by its identifier.
   */
  abstract T findById(ID id);

  /**
   * Find all entities.
   */
  abstract T[] findAll();

  /**
   * Save a new entity.
   */
  abstract T save(T entity);

  /**
   * Update an existing entity.
   */
  abstract T update(T entity);

  /**
   * Delete an entity by its identifier.
   */
  abstract bool deleteById(ID id);

  /**
   * Delete an entity.
   */
  bool remove(T entity) {
    // Default implementation - can be overridden
    static if (__traits(hasMember, T, "id")) {
      return deleteById(entity.id);
    } else {
      return false;
    }
  }

  /**
   * Check if an entity exists by its identifier.
   */
  bool exists(ID id) {
    return findById(id) !is null;
  }

  /**
   * Count all entities.
   */
  size_t count() {
    return findAll().length;
  }

  /**
   * Find entities matching a predicate.
   */
  T[] findWhere(bool delegate(T) @safe predicate) {
    import std.algorithm : filter;
    import std.array : array;
    
    return findAll().filter!((T entity) => predicate(entity)).array;
  }

  /**
   * Find the first entity matching a predicate.
   */
  T findFirst(bool delegate(T) @safe predicate) {
    auto results = findWhere(predicate);
    return results.length > 0 ? results[0] : null;
  }

  /**
   * Count entities matching a predicate.
   */
  size_t countWhere(bool delegate(T) @safe predicate) {
    return findWhere(predicate).length;
  }
}
