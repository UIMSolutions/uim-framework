/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.entity;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * Entity state enumeration
 */
enum EntityState {
    New, // Entity is newly created, not persisted
    Clean, // Entity is unchanged since loaded
    Dirty, // Entity has been modified
    Deleted // Entity is marked for deletion
}

/**
 * Base entity class with common functionality
 */
class UIMEntity : UIMObject, IEntity {
    // --- MISSING INTERFACE FIELDS ---
    protected string _description;
    protected string _versionDescription;

    // Description
    override string description() {
        return _description;
    }

    override IEntity description(string value) {
        _description = value;
        return this;
    }

    // Versioning
    override string versionDescription() {
        return _versionDescription;
    }

    override IEntity versionDescription(string value) {
        _versionDescription = value;
        return this;
    }

    protected UUID _id;
    protected string _name;
    protected SysTime _createdAt;
    protected SysTime _updatedAt;
    protected EntityState _state;
    protected string[string] _attributes;

    protected string[] _errors;
    protected string[string] _originalAttributes;

    // Getters
    UUID id() {
        return _id;
    }

    string name() {
        return _name;
    }

    SysTime createdAt() {
        return _createdAt;
    }

    SysTime updatedAt() {
        return _updatedAt;
    }

    EntityState state() {
        return _state;
    }

    string[string] attributes() {
        return _attributes;
    }

    // Setters
    IEntity id(UUID value) {
        _id = value;
        return this;
    }

    IEntity name(string value) {
        _name = value;
        return this;
    }

    IEntity createdAt(SysTime value) {
        _createdAt = value;
        return this;
    }

    IEntity updatedAt(SysTime value) {
        _updatedAt = value;
        return this;
    }

    IEntity state(EntityState value) {
        _state = value;
        return this;
    }

    IEntity attributes(string[string] value) {
        _attributes = value;
        return this;
    }

    this() {
        super();
        this.id(randomUUID());
        this.createdAt(Clock.currTime());
        this.updatedAt(Clock.currTime());
        this.state(EntityState.New);
    }

  void readFromMap(string[string] data, bool usePrefix = false) {
    data.byKeyValue.each!((k, v) => this[k] = v);
  }

  // Read data from request
  void readFromRequest(string[string] requestValues, bool usePrefix = true) {
    auto myData = selector(requestValues);
    foreach (key, value; myData) {
      this[key] = value;
    }
  }

    this(UUID entityId) {
        this();
        this.id(entityId);
    }

    // State checks
    bool isNew() {
        return this.state() == EntityState.New;
    }

    bool isClean() {
        return this.state() == EntityState.Clean;
    }

    bool isDirty() {
        return this.state() == EntityState.Dirty;
    }

    bool isDeleted() {
        return this.state() == EntityState.Deleted;
    }

    // Attribute management
    string getAttribute(string key, string defaultValue = "") {
        if (auto ptr = key in _attributes) {
            return *ptr;
        }
        return defaultValue;
    }

    override IEntity setAttribute(string key, string value) {
        _attributes[key] = value;
        if (_state == EntityState.Clean) {
            markDirty();
        }
        return this;
    }

    bool hasAttribute(string key) {
        return (key in _attributes) ? true : false;
    }

    override IEntity removeAttribute(string key) {
        _attributes.remove(key);
        if (_state == EntityState.Clean) {
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
        if (_state != EntityState.New && _state != EntityState.Deleted) {
            _state = EntityState.Dirty;
            _updatedAt = Clock.currTime();
        }
    }

    void markClean() {
        if (_state != EntityState.Deleted) {
            _state = EntityState.Clean;
            _originalAttributes = _attributes.dup;
        }
    }

    void markDeleted() {
        _state = EntityState.Deleted;
        _updatedAt = Clock.currTime();
    }

    // Serialization
    override Json toJson(string[] showKeys = null, string[] hideKeys = null) {
        Json json = super.toJson(showKeys, hideKeys);
        json["id"] = this.id().toString();
        json["name"] = this.name();
        json["state"] = this.state().to!string;
        json["createdAt"] = this.createdAt().toISOExtString();
        json["updatedAt"] = this.updatedAt().toISOExtString();

        Json attrsJson;
        foreach (key, value; this.attributes()) {
            attrsJson[key] = value;
        }
        json["attributes"] = attrsJson;

        return json;
    }

    override string[string] toAA() {
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
auto entity() {
    return new UIMEntity();
}

auto entity(UUID id) {
    return new UIMEntity(id);
}

auto entity(string name) {
    auto e = new UIMEntity();
    e.name(name);
    return e;
}

unittest {
    auto entity1 = entity("Test Entity");
    assert(entity1.name() == "Test Entity");
    assert(entity1.isNew());
    assert(!entity1.isDirty());

    entity1.setAttribute("key1", "value1");
    assert(entity1.hasAttribute("key1"));
    assert(entity1.getAttribute("key1") == "value1");

    entity1.markClean();
    assert(entity1.isClean());

    entity1.setAttribute("key2", "value2");
    assert(entity1.isDirty());

    entity1.markDeleted();
    assert(entity1.isDeleted());
}
