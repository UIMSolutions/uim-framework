/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.entity;

import uim.core;
import uim.oop;

import std.datetime : SysTime, Clock;
import std.uuid : UUID, randomUUID;

@safe:

/**
 * Entity state enumeration
 */
enum EntityState {
    New,        // Entity is newly created, not persisted
    Clean,      // Entity is unchanged since loaded
    Dirty,      // Entity has been modified
    Deleted     // Entity is marked for deletion
}


/**
 * Base entity class with common functionality
 */
class DEntity : UIMObject, IEntity {
    protected UUID _id;
    protected string _name;
    protected SysTime _createdAt;
    protected SysTime _updatedAt;
    protected EntityState _state;
    protected string[string] _attributes;
    
    protected string[] _errors;
    protected string[string] _originalAttributes;
    
    // Getters
    UUID id() { return _id; }
    string name() { return _name; }
    SysTime createdAt() { return _createdAt; }
    SysTime updatedAt() { return _updatedAt; }
    EntityState state() { return _state; }
    string[string] attributes() { return _attributes; }
    
    // Setters
    void id(UUID value) { _id = value; }
    void name(string value) { _name = value; }
    void createdAt(SysTime value) { _createdAt = value; }
    void updatedAt(SysTime value) { _updatedAt = value; }
    void state(EntityState value) { _state = value; }
    void attributes(string[string] value) { _attributes = value; }
    
    this() {
        super();
        this.id(randomUUID());
        this.createdAt(Clock.currTime());
        this.updatedAt(Clock.currTime());
        this.state(EntityState.New);
    }
    
    this(UUID entityId) {
        this();
        this.id(entityId);
    }
    
    // State checks
    bool isNew() { return this.state() == EntityState.New; }
    bool isClean() { return this.state() == EntityState.Clean; }
    bool isDirty() { return this.state() == EntityState.Dirty; }
    bool isDeleted() { return this.state() == EntityState.Deleted; }
    
    // Attribute management
    string getAttribute(string key, string defaultValue = "") {
        auto attrs = this.attributes();
        return (key in attrs) ? attrs[key] : defaultValue;
    }
    
    IEntity setAttribute(string key, string value) {
        auto attrs = this.attributes();
        attrs[key] = value;
        this.attributes(attrs);
        if (this.state() == EntityState.Clean) {
            markDirty();
        }
        return this;
    }
    
    bool hasAttribute(string key) {
        auto attrs = this.attributes();
        return (key in attrs) !is null;
    }
    
    IEntity removeAttribute(string key) {
        auto attrs = this.attributes();
        attrs.remove(key);
        this.attributes(attrs);
        if (this.state() == EntityState.Clean) {
            markDirty();
        }
        return this;
    }
    
    // Validation
    bool isValid() {
        return _errors.length == 0;
    }
    
    string[] errors() {
        return _errors.dup;
    }
    
    IEntity addError(string error) {
        _errors ~= error;
        return this;
    }
    
    IEntity clearErrors() {
        _errors = [];
        return this;
    }
    
    // Lifecycle
    void markDirty() {
        if (this.state() != EntityState.New && this.state() != EntityState.Deleted) {
            this.state(EntityState.Dirty);
            this.updatedAt(Clock.currTime());
        }
    }
    
    void markClean() {
        if (this.state() != EntityState.Deleted) {
            this.state(EntityState.Clean);
            _originalAttributes = this.attributes().dup;
        }
    }
    
    void markDeleted() {
        this.state(EntityState.Deleted);
        this.updatedAt(Clock.currTime());
    }
    
    // Serialization
    string toJson() {
        import std.json : JSONValue;
        import std.conv : to;
        
        JSONValue json;
        json["id"] = this.id().toString();
        json["name"] = this.name();
        json["state"] = this.state().to!string;
        json["createdAt"] = this.createdAt().toISOExtString();
        json["updatedAt"] = this.updatedAt().toISOExtString();
        
        JSONValue attrsJson;
        foreach (key, value; this.attributes()) {
            attrsJson[key] = value;
        }
        json["attributes"] = attrsJson;
        
        return json.toString();
    }
    
    string[string] toAA() {
        import std.conv : to;
        
        string[string] result;
        result["id"] = this.id().toString();
        result["name"] = this.name();
        result["state"] = this.state().to!string;
        result["createdAt"] = this.createdAt().toISOExtString();
        result["updatedAt"] = this.updatedAt().toISOExtString();
        
        foreach (key, value; this.attributes()) {
            result[key] = value;
        }
        
        return result;
    }
}

// Factory function
auto Entity() {
    return new DEntity();
}

auto Entity(UUID id) {
    return new DEntity(id);
}

auto Entity(string name) {
    auto entity = new DEntity();
    entity.name(name);
    return entity;
}

unittest {
    writeln("Testing DEntity class...");
    
    auto entity = Entity("Test Entity");
    assert(entity.name() == "Test Entity");
    assert(entity.isNew());
    assert(!entity.isDirty());
    
    entity.setAttribute("key1", "value1");
    assert(entity.hasAttribute("key1"));
    assert(entity.getAttribute("key1") == "value1");
    
    entity.markClean();
    assert(entity.isClean());
    
    entity.setAttribute("key2", "value2");
    assert(entity.isDirty());
    
    entity.markDeleted();
    assert(entity.isDeleted());
    
    writeln("DEntity tests passed!");
}
