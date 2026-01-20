/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.repositories.unitofwork;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Unit of Work implementation for managing transactional operations.
 */
class UnitOfWork(T, ID) : IUnitOfWork {
  private enum ChangeType {
    Added,
    Modified,
    Removed
  }

  private struct Change {
    T entity;
    ChangeType type;
  }

  private Change[] _changes;
  private IRepository!(T, ID) _repository;

  /**
     * Constructor.
     */
  this(IRepository!(T, ID) repository) {
    _repository = repository;
  }

  /**
     * Register a new entity.
     */
  void registerNew(T entity) {
    _changes ~= Change(entity, ChangeType.Added);
  }

  /**
     * Register a modified entity.
     */
  void registerDirty(T entity) {
    _changes ~= Change(entity, ChangeType.Modified);
  }

  /**
     * Register a removed entity.
     */
  void registerDeleted(T entity) {
    _changes ~= Change(entity, ChangeType.Removed);
  }

  /**
     * Commit all pending changes.
     */
  void commit() {
    foreach (change; _changes) {
      final switch (change.type) {
      case ChangeType.Added:
        _repository.add(change.entity);
        break;
      case ChangeType.Modified:
        _repository.update(change.entity);
        break;
      case ChangeType.Removed:
        _repository.remove(change.entity);
        break;
      }
    }
    _changes = [];
  }

  /**
     * Rollback all pending changes.
     */
  void rollback() {
    _changes = [];
  }

  /**
     * Check if there are pending changes.
     */
  bool hasChanges() {
    return _changes.length > 0;
  }

  /**
     * Get the number of pending changes.
     */
  size_t changeCount() {
    return _changes.length;
  }
}

// Unit tests
/*class MyException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) pure nothrow @nogc @safe {
    super(msg, file, line, nextInChain);
  }
}

unittest {
  mixin(ShowTest!"Testing UnitOfWork");

  class Entity {
    int id;
    string value;

    this(int id, string value) {
      this.id = id;
      this.value = value;
    }
  }

  auto repo = new InMemoryRepository!(int, Entity)((Entity e) => e.id);
  auto uow = new UnitOfWork!(int, Entity)(repo);

  // Register changes
  auto e1 = new Entity(1, "First");
  auto e2 = new Entity(2, "Second");
  auto e3 = new Entity(3, "Third");

  uow.registerNew(e1);
  uow.registerNew(e2);
  assert(uow.hasChanges());
  assert(uow.changeCount() == 2);

  // Commit changes
  uow.commit();
  assert(!uow.hasChanges());
  assert(repo.count() == 2);
  assert(repo.exists(1));
  assert(repo.exists(2));

  // Modify and commit
  e1.value = "Modified";
  uow.registerDirty(e1);
  uow.commit();
  auto found = repo.findById(1);
  assert(found.value == "Modified");

  // Delete and commit
  uow.registerDeleted(e2);
  uow.commit();
  assert(repo.count() == 1);
  assert(!repo.exists(2));

  // Test rollback
  uow.registerNew(e3);
  assert(uow.hasChanges());
  uow.rollback();
  assert(!uow.hasChanges());
  assert(!repo.exists(3));
}
*/