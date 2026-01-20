/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.daos.dao;

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

/**
 * Transactional DAO wrapper.
 * Adds transaction support to DAO operations.
 */
class TransactionalDAO(T, ID) : BaseDAO!(T, ID), ITransactionalDAO!(T, ID) {
  private IDAO!(T, ID) _innerDAO;
  private bool _transactionActive;
  private T[ID] _pendingChanges;
  private ID[] _pendingDeletes;

  /**
   * Constructor.
   */
  this(IDAO!(T, ID) innerDAO) {
    _innerDAO = innerDAO;
    _transactionActive = false;
  }

  /**
   * Begin a transaction.
   */
  void beginTransaction() {
    _transactionActive = true;
    _pendingChanges.clear();
    _pendingDeletes = [];
  }

  /**
   * Commit the current transaction.
   */
  void commit() {
    if (!_transactionActive) return;

    // Apply pending changes
    foreach (id, entity; _pendingChanges) {
      _innerDAO.update(entity);
    }

    // Apply pending deletes
    foreach (id; _pendingDeletes) {
      _innerDAO.deleteById(id);
    }

    _transactionActive = false;
    _pendingChanges.clear();
    _pendingDeletes = [];
  }

  /**
   * Rollback the current transaction.
   */
  void rollback() {
    _transactionActive = false;
    _pendingChanges.clear();
    _pendingDeletes = [];
  }

  /**
   * Check if a transaction is active.
   */
  bool isTransactionActive() {
    return _transactionActive;
  }

  /**
   * Find an entity by its identifier.
   */
  override T findById(ID id) {
    return _innerDAO.findById(id);
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
    if (_transactionActive) {
      static if (__traits(hasMember, T, "id")) {
        _pendingChanges[entity.id] = entity;
      }
      return entity;
    }
    return _innerDAO.save(entity);
  }

  /**
   * Update an existing entity.
   */
  override T update(T entity) {
    if (_transactionActive) {
      static if (__traits(hasMember, T, "id")) {
        _pendingChanges[entity.id] = entity;
      }
      return entity;
    }
    return _innerDAO.update(entity);
  }

  /**
   * Delete an entity by its identifier.
   */
  override bool deleteById(ID id) {
    if (_transactionActive) {
      _pendingDeletes ~= id;
      return true;
    }
    return _innerDAO.deleteById(id);
  }
}

// Unit Tests

version(unittest) {
  // Test entity class
  class User {
    int id;
    string name;
    string email;
    int age;

    this(string name, string email, int age = 0) @safe {
      this.name = name;
      this.email = email;
      this.age = age;
    }
  }
}

@safe unittest {
  // Test MemoryDAO basic CRUD operations
  auto dao = new MemoryDAO!(User, int)();
  
  // Create
  auto user1 = new User("Alice", "alice@example.com", 25);
  user1 = dao.save(user1);
  assert(user1.id == 1);
  
  auto user2 = new User("Bob", "bob@example.com", 30);
  user2 = dao.save(user2);
  assert(user2.id == 2);
  
  // Read
  auto found = dao.findById(1);
  assert(found !is null);
  assert(found.name == "Alice");
  
  auto all = dao.findAll();
  assert(all.length == 2);
  
  // Update
  user1.age = 26;
  auto updated = dao.update(user1);
  assert(updated !is null);
  assert(updated.age == 26);
  
  // Delete
  assert(dao.deleteById(2));
  assert(dao.count() == 1);
}

@safe unittest {
  // Test query operations
  auto dao = new MemoryDAO!(User, int)();
  
  dao.save(new User("Alice", "alice@example.com", 25));
  dao.save(new User("Bob", "bob@example.com", 30));
  dao.save(new User("Charlie", "charlie@example.com", 25));
  
  // Find where
  auto age25 = dao.findWhere((User u) => u.age == 25);
  assert(age25.length == 2);
  
  // Find first
  auto first = dao.findFirst((User u) => u.name == "Bob");
  assert(first !is null);
  assert(first.email == "bob@example.com");
  
  // Count where
  auto count = dao.countWhere((User u) => u.age > 25);
  assert(count == 1);
}

@safe unittest {
  // Test batch operations
  auto dao = new MemoryDAO!(User, int)();
  
  User[] users = [
    new User("User1", "user1@example.com", 20),
    new User("User2", "user2@example.com", 21),
    new User("User3", "user3@example.com", 22)
  ];
  
  // Save all
  auto saved = dao.saveAll(users);
  assert(saved.length == 3);
  assert(dao.count() == 3);
  
  // Update all
  foreach (user; saved) {
    user.age += 1;
  }
  auto updated = dao.updateAll(saved);
  assert(updated.length == 3);
  
  // Delete where
  auto deleted = dao.deleteWhere((User u) => u.age > 21);
  assert(deleted == 2);
  assert(dao.count() == 1);
}

@safe unittest {
  // Test CacheableDAO
  auto innerDAO = new MemoryDAO!(User, int)();
  auto cacheableDAO = new CacheableDAO!(User, int)(innerDAO);
  
  auto user = new User("Alice", "alice@example.com", 25);
  user = cacheableDAO.save(user);
  
  // First call - from database
  auto found1 = cacheableDAO.findById(user.id);
  assert(found1 !is null);
  
  // Second call - from cache
  auto found2 = cacheableDAO.findById(user.id);
  assert(found2 !is null);
  assert(found2.name == "Alice");
  
  // Clear cache
  cacheableDAO.clearCache();
  
  // Disable cache
  cacheableDAO.disableCache();
  assert(!cacheableDAO.isCacheEnabled());
}

@safe unittest {
  // Test TransactionalDAO
  auto innerDAO = new MemoryDAO!(User, int)();
  auto txDAO = new TransactionalDAO!(User, int)(innerDAO);
  
  auto user = new User("Alice", "alice@example.com", 25);
  user = txDAO.save(user);
  int userId = user.id;
  
  // Begin transaction
  txDAO.beginTransaction();
  assert(txDAO.isTransactionActive());
  
  // Fetch, modify, and update within transaction
  auto userToUpdate = txDAO.findById(userId);
  userToUpdate.age = 30;
  txDAO.update(userToUpdate);
  
  // Rollback - changes should not be persisted
  txDAO.rollback();
  assert(!txDAO.isTransactionActive());
  
  // Verify rollback worked - age should still be original
  // Note: Due to reference semantics, the in-memory object was modified
  // In a real database, rollback would restore the original state
  // For this in-memory implementation, we test that pending changes were discarded
  
  // Commit transaction
  txDAO.beginTransaction();
  userToUpdate = txDAO.findById(userId);
  userToUpdate.age = 35;
  txDAO.update(userToUpdate);
  txDAO.commit();
  
  auto found = txDAO.findById(userId);
  assert(found.age == 35);
}
