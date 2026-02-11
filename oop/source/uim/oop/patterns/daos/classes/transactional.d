module uim.oop.patterns.daos.classes.transactional;

import uim.oop;

mixin(ShowModule!());

@safe:
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
    if (_transactionActive && id in _pendingChanges) {
      return _pendingChanges[id];
    }
    if (_transactionActive && id in _pendingDeletes) {
      return null;
    }
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