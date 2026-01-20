module uim.entities.interfaces.collection;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * Entity collection interface
 */
interface IEntityCollection {
    // Basic operations
    size_t count();
    bool isEmpty();
    void clear();
    
    // Add/Remove
    IEntityCollection add(IEntity entity);
    IEntityCollection remove(IEntity entity);
    IEntityCollection removeById(UUID id);
    
    // Query
    IEntity get(UUID id);
    IEntity findByName(string name);
    IEntity[] findByAttribute(string key, string value);
    IEntity[] getAll();
    bool contains(IEntity entity);
    bool containsId(UUID id);
    
    // State filtering
    IEntity[] getNew();
    IEntity[] getDirty();
    IEntity[] getClean();
    IEntity[] getDeleted();
    
    // Bulk operations
    void markAllClean();
    void markAllDirty();
}