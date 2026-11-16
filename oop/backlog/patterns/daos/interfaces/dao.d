module uim.oop.patterns.daos.interfaces.dao;

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
