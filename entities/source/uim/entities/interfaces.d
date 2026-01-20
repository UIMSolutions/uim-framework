module uim.entities.interfaces;

import uim.core;
import uim.events;
import uim.entities.entity;

@safe:
/**
 * Entity interface that defines the contract for all entities
 */
interface IEntity {
    // Identity
    UUID id();
    IEntity id(UUID value);
    
    string name();
    IEntity name(string value);
    
    // Timestamps
    SysTime createdAt();
    IEntity createdAt(SysTime value);
    
    SysTime updatedAt();
    IEntity updatedAt(SysTime value);
    
    // State management
    EntityState state();
    IEntity state(EntityState value);
    
    bool isNew();
    bool isClean();
    bool isDirty();
    bool isDeleted();
    
    // Data management
    string[string] attributes();
    IEntity attributes(string[string] value);
    
    string getAttribute(string key, string defaultValue = "");
    IEntity setAttribute(string key, string value);
    bool hasAttribute(string key);
    IEntity removeAttribute(string key);
    
    // Validation
    bool isValid();
    string[] errors();
    IEntity addError(string error);
    IEntity clearErrors();
    
    // Lifecycle
    void markDirty();
    void markClean();
    void markDeleted();
    
    // Serialization
    string toJson();
    string[string] toAA();
}