module uim.entities.interfaces.manager;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * Entity manager interface that coordinates entity lifecycle with events
 */
interface IEntityManager {
  /**
   * Set validator for entities
   */
  IEntityManager validator(UIMEntityValidator val);

  /**
   * Get event dispatcher
   */
  UIMEventDispatcher eventDispatcher();

  /**
   * Create a new entity with lifecycle events
   */
  IEntity create(IEntity entity);

  /**
   * Update an existing entity with lifecycle events
   */
  IEntity update(IEntity entity);

  /**
   * Delete an entity with lifecycle events
   */
  void remove(IEntity entity);

  /**
   * Find entity by ID
   */
  IEntity find(UUID id);

  /**
   * Find all entities
   */
  IEntity[] findAll();

  /**
   * Find entity by name
   */
  IEntity findByName(string name);

  /**
   * Find entities by attribute
   */
  IEntity[] findByAttribute(string key, string value);

  /**
   * Get repository
   */
  UIMEntityRepository repository();
}
