/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.daos.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Data Access Object (DAO) interface.
 * Provides an abstract interface to persistence mechanisms.
 * Separates business logic from data access logic.
 */
interface IDAO(T, ID) {
  /**
   * Find an entity by its identifier.
   * Params:
   *   id = The unique identifier
   * Returns: The entity if found, null otherwise
   */
  T findById(ID id);

  /**
   * Find all entities.
   * Returns: Array of all entities
   */
  T[] findAll();

  /**
   * Save a new entity.
   * Params:
   *   entity = The entity to save
   * Returns: The saved entity with generated ID
   */
  T save(T entity);

  /**
   * Update an existing entity.
   * Params:
   *   entity = The entity to update
   * Returns: The updated entity
   */
  T update(T entity);

  /**
   * Delete an entity by its identifier.
   * Params:
   *   id = The identifier of the entity to delete
   * Returns: true if deleted successfully
   */
  bool deleteById(ID id);

  /**
   * Delete an entity.
   * Params:
   *   entity = The entity to delete
   * Returns: true if deleted successfully
   */
  bool remove(T entity);

  /**
   * Check if an entity exists by its identifier.
   * Params:
   *   id = The identifier to check
   * Returns: true if exists
   */
  bool exists(ID id);

  /**
   * Count all entities.
   * Returns: The total number of entities
   */
  size_t count();
}

/**
 * Extended DAO interface with query capabilities.
 */
interface IQueryableDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Find entities matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: Array of matching entities
   */
  T[] findWhere(bool delegate(T) @safe predicate);

  /**
   * Find the first entity matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: The first matching entity or null
   */
  T findFirst(bool delegate(T) @safe predicate);

  /**
   * Count entities matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: The count of matching entities
   */
  size_t countWhere(bool delegate(T) @safe predicate);
}

/**
 * Transaction support for DAO operations.
 */
interface ITransactionalDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Begin a transaction.
   */
  void beginTransaction();

  /**
   * Commit the current transaction.
   */
  void commit();

  /**
   * Rollback the current transaction.
   */
  void rollback();

  /**
   * Check if a transaction is active.
   * Returns: true if transaction is active
   */
  bool isTransactionActive();
}

/**
 * Cacheable DAO interface.
 */
interface ICacheableDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Enable caching.
   */
  void enableCache();

  /**
   * Disable caching.
   */
  void disableCache();

  /**
   * Clear the cache.
   */
  void clearCache();

  /**
   * Check if caching is enabled.
   * Returns: true if caching is enabled
   */
  bool isCacheEnabled();
}

/**
 * Batch operations interface for DAO.
 */
interface IBatchDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Save multiple entities.
   * Params:
   *   entities = The entities to save
   * Returns: The saved entities
   */
  T[] saveAll(T[] entities);

  /**
   * Update multiple entities.
   * Params:
   *   entities = The entities to update
   * Returns: The updated entities
   */
  T[] updateAll(T[] entities);

  /**
   * Delete multiple entities by their identifiers.
   * Params:
   *   ids = The identifiers of entities to delete
   * Returns: The number of deleted entities
   */
  size_t deleteAllById(ID[] ids);

  /**
   * Delete all entities matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: The number of deleted entities
   */
  size_t deleteWhere(bool delegate(T) @safe predicate);
}
