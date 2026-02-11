/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.classes.cacheable;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Cacheable DAO decorator.
 * Adds caching capabilities to any DAO implementation.
 */
class CacheableDAO(T, ID) : BaseDAO!(T, ID), ICacheableDAO!(T, ID) {
  private IDAO!(T, ID) _innerDAO;
  private T[ID] _cache;
  private bool _cacheEnabled;

  /**
   * Constructor.
   * Params:
   *   innerDAO = The DAO to wrap with caching
   */
  this(IDAO!(T, ID) innerDAO) {
    _innerDAO = innerDAO;
    _cacheEnabled = true;
  }

  /**
   * Find an entity by its identifier.
   */
  override T findById(ID id) {
    if (_cacheEnabled && id in _cache) {
      return _cache[id];
    }
    
    auto entity = _innerDAO.findById(id);
    if (_cacheEnabled && entity !is null) {
      _cache[id] = entity;
    }
    return entity;
  }

  /**
   * Find all entities.
   */
  override T[] findAll() {
    return _innerDAO.findAll();
  }

  /**
   * Save a new entity.
   */
  override T save(T entity) {
    auto saved = _innerDAO.save(entity);
    if (_cacheEnabled && saved !is null) {
      static if (__traits(hasMember, T, "id")) {
        _cache[saved.id] = saved;
      }
    }
    return saved;
  }

  /**
   * Update an existing entity.
   */
  override T update(T entity) {
    auto updated = _innerDAO.update(entity);
    if (_cacheEnabled && updated !is null) {
      static if (__traits(hasMember, T, "id")) {
        _cache[updated.id] = updated;
      }
    }
    return updated;
  }

  /**
   * Delete an entity by its identifier.
   */
  override bool deleteById(ID id) {
    bool deleted = _innerDAO.deleteById(id);
    if (_cacheEnabled && deleted) {
      _cache.remove(id);
    }
    return deleted;
  }

  /**
   * Enable caching.
   */
  void enableCache() {
    _cacheEnabled = true;
  }

  /**
   * Disable caching.
   */
  void disableCache() {
    _cacheEnabled = false;
  }

  /**
   * Clear the cache.
   */
  void clearCache() {
    _cache.clear();
  }

  /**
   * Check if caching is enabled.
   */
  bool isCacheEnabled() {
    return _cacheEnabled;
  }
}
