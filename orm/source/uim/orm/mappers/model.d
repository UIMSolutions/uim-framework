/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.orm.mappers.model;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * Base ORM Model class
 */
abstract class ORMModel : UIMObject, IORMModel, IEntity {
  protected UUID _id;
  protected string _name;
  protected SysTime _createdAt;
  protected SysTime _updatedAt;
  protected EntityState _state;
  protected string[string] _attributes;
  protected string[] _errors;
  protected string[string] _originalAttributes;
  protected IValuebase _database;
  protected IQuery _queryBuilder;

  this() {
    super();
    this.id(randomUUID());
    this.createdAt(Clock.currTime());
    this.updatedAt(Clock.currTime());
    this.state(EntityState.New);
  }

  // Abstract methods
  abstract string tableName();
  abstract string primaryKey();
  abstract string[string] columnMappings();
  abstract bool hasTimestamps();

  // IEntity implementation
  UUID id() { return _id; }
  IEntity id(UUID value) { _id = value; return this; }

  string name() { return _name; }
  IEntity name(string value) { _name = value; return this; }

  SysTime createdAt() { return _createdAt; }
  IEntity createdAt(SysTime value) { _createdAt = value; return this; }

  SysTime updatedAt() { return _updatedAt; }
  IEntity updatedAt(SysTime value) { _updatedAt = value; return this; }

  EntityState state() { return _state; }
  IEntity state(EntityState value) { _state = value; return this; }

  string[string] attributes() { return _attributes.dup; }
  IEntity attributes(string[string] value) { _attributes = value.dup; return this; }

  string getAttribute(string key, string defaultValue = "") {
    if (auto ptr = key in _attributes) {
      return *ptr;
    }
    return defaultValue;
  }

  IEntity setAttribute(string key, string value) {
    _attributes[key] = value;
    if (_state == EntityState.Clean) {
      markDirty();
    }
    return this;
  }

  bool hasAttribute(string key) {
    return (key in _attributes) !is null;
  }

  IEntity removeAttribute(string key) {
    _attributes.remove(key);
    if (_state == EntityState.Clean) {
      markDirty();
    }
    return this;
  }

  bool isValid() {
    return _errors.length == 0;
  }

  string[] errors() { return _errors.dup; }

  IEntity addError(string error) {
    _errors ~= error;
    return this;
  }

  IEntity clearErrors() {
    _errors = [];
    return this;
  }

  void markDirty() {
    _state = EntityState.Dirty;
  }

  void markClean() {
    _state = EntityState.Clean;
  }

  void markDeleted() {
    _state = EntityState.Deleted;
  }

  bool isNew() { return _state == EntityState.New; }
  bool isClean() { return _state == EntityState.Clean; }
  bool isDirty() { return _state == EntityState.Dirty; }
  bool isDeleted() { return _state == EntityState.Deleted; }

  Json toJson(string[] showKeys = null, string[] hideKeys = null) {
    Json result = Json.emptyObject;
    foreach (key, value; _attributes) {
      result[key] = Json(value);
    }
    return result;
  }

  string[string] toAA() {
    return _attributes.dup;
  }

  // IORMModel implementation
  void find(long id, void delegate(bool success, IEntity entity) @safe callback) @trusted {
    if (_database !is null) {
      _queryBuilder = _database.query(null);
      // Implementation would continue with actual query
    }
  }

  void all(void delegate(bool success, IEntity[] entities) @safe callback) @trusted {
    if (_database !is null) {
      _queryBuilder = _database.query(null);
      // Implementation would continue with actual query
    }
  }

  void create(IEntity entity, void delegate(bool success, IEntity result) @safe callback) @trusted {
    // Insert into database
    if (_database !is null) {
      // Implementation continues with INSERT query
    }
  }

  void update(IEntity entity, void delegate(bool success, IEntity result) @safe callback) @trusted {
    // Update in database
    if (_database !is null) {
      // Implementation continues with UPDATE query
    }
  }

  void delete(IEntity entity, void delegate(bool success) @safe callback) @trusted {
    // Delete from database
    if (_database !is null) {
      // Implementation continues with DELETE query
    }
  }

  IQuery query() {
    if (_queryBuilder is null && _database !is null) {
      _queryBuilder = new SQLQueryBuilder(_database);
      _queryBuilder.from(tableName());
    }
    return _queryBuilder;
  }

  IValuebase database() {
    return _database;
  }

  void setDatabase(IValuebase db) @trusted {
    _database = db;
  }
}

/**
 * Data mapper for converting database rows to entity objects
 */
class EntityMapper : UIMObject {
  protected IORMModel _model;

  this(IORMModel model) {
    super();
    _model = model;
  }

  IEntity mapFromRow(Json row) {
    auto entity = cast(ORMModel)_model;
    if (entity is null) return null;

    foreach (key, value; row.byKeyValue()) {
      entity.setAttribute(key, value.to!string);
    }

    entity.markClean();
    return entity;
  }

  Json mapToRow(IEntity entity) {
    Json result = Json.emptyObject;
    foreach (key, value; entity.attributes()) {
      result[key] = Json(value);
    }
    return result;
  }
}
