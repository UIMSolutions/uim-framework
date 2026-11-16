/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.classes.memory;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * In-memory DAO implementation for testing and simple use cases.
 */
class MemoryDAO(T, ID) : BaseDAO!(T, ID), IBatchDAO!(T, ID) {
  private T[ID] _storage;
  private ID _nextId;

  /**
   * Constructor.
   */
  this() {
    _storage = null;
    static if (is(ID == int) || is(ID == long) || is(ID == uint) || is(ID == ulong)) {
      _nextId = cast(ID)1;
    }
  }

  /**
   * Find an entity by its identifier.
   */
  override T findById(ID id) {
    return id in _storage ? _storage[id] : null;
  }

  /**
   * Find all entities.
   */
  override T[] findAll() {
    import std.array : array;
    return _storage.values.array;
  }

  /**
   * Save a new entity.
   */
  override T save(T entity) {
    static if (__traits(hasMember, T, "id")) {
      static if (is(ID == int) || is(ID == long) || is(ID == uint) || is(ID == ulong)) {
        if (entity.id == cast(ID)0) {
          entity.id = _nextId++;
        }
      }
      _storage[entity.id] = entity;
      return entity;
    } else {
      static assert(0, "Entity type must have an 'id' field");
    }
  }

  /**
   * Update an existing entity.
   */
  override T update(T entity) {
    static if (__traits(hasMember, T, "id")) {
      if (entity.id in _storage) {
        _storage[entity.id] = entity;
        return entity;
      }
      return null;
    } else {
      static assert(0, "Entity type must have an 'id' field");
    }
  }

  /**
   * Delete an entity by its identifier.
   */
  override bool deleteById(ID id) {
    if (id in _storage) {
      _storage.remove(id);
      return true;
    }
    return false;
  }

  /**
   * Save multiple entities.
   */
  T[] saveAll(T[] entities) {
    T[] saved;
    foreach (entity; entities) {
      saved ~= save(entity);
    }
    return saved;
  }

  /**
   * Update multiple entities.
   */
  T[] updateAll(T[] entities) {
    T[] updated;
    foreach (entity; entities) {
      auto result = update(entity);
      if (result !is null) {
        updated ~= result;
      }
    }
    return updated;
  }

  /**
   * Delete multiple entities by their identifiers.
   */
  size_t deleteAllById(ID[] ids) {
    size_t deleted = 0;
    foreach (id; ids) {
      if (deleteById(id)) {
        deleted++;
      }
    }
    return deleted;
  }

  /**
   * Delete all entities matching a predicate.
   */
  size_t deleteWhere(bool delegate(T) @safe predicate) {
    auto toDelete = findWhere(predicate);
    size_t deleted = 0;
    foreach (entity; toDelete) {
      static if (__traits(hasMember, T, "id")) {
        if (deleteById(entity.id)) {
          deleted++;
        }
      }
    }
    return deleted;
  }

  /**
   * Clear all data from storage.
   */
  void clear() {
    _storage.clear();
    static if (is(ID == int) || is(ID == long) || is(ID == uint) || is(ID == ulong)) {
      _nextId = cast(ID)1;
    }
  }
}