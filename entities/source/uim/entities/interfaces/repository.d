module uim.entities.interfaces.repository;

import uim.entities;

mixin(ShowModule!());

@safe:


/**
 * Repository interface for entity persistence
 */
interface IEntityRepository {
    // CRUD operations
    IEntity find(UUID id);
    IEntity[] findAll();
    IEntity save(IEntity entity);
    void remove(IEntity entity);
    void removeById(UUID id);
    
    // Query operations
    IEntity findByName(string name);
    IEntity[] findByAttribute(string key, string value);
    IEntity[] findByState(EntityState state);
    
    // Batch operations
    IEntity[] saveAll(IEntity[] entities);
    void removeAll(IEntity[] entities);
    
    // Count
    size_t count();
    size_t countByState(EntityState state);
}