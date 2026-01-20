module uim.oop.patterns.repositories.interfaces.repository;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Repository interface for managing entities.
 * Provides CRUD operations and query capabilities.
 */
interface IRepository(K, V) {
  // Add a new entity to the repository.
  void add(V entity);

  // Update an existing entity in the repository.
  void update(V entity);

  /**
     * Remove an entity from the repository.
     */
  void remove(V entity);

  /**
     * Remove an entity by its ID.
     */
  bool removeById(K id);

  /**
     * Find an entity by its ID.
     * Returns: The entity or null if not found
     */
  V findById(K id);

  /**
     * Get all entities in the repository.
     */
  V[] findAll();

  /**
     * Check if an entity with the given ID exists.
     */
  bool exists(K id);

  /**
     * Get the total count of entities.
     */
  size_t count();

  /**
     * Clear all entities from the repository.
     */
  void clear();
}