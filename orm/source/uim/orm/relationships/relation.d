/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.orm.relationships.relation;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * Relationship types
 */
enum RelationType {
  HasOne,
  HasMany,
  BelongsTo,
  BelongsToMany,
  HasManyThrough
}

/**
 * Relationship definition
 */
class Relationship : UIMObject {
  protected RelationType _type;
  protected string _foreignModel;
  protected string _foreignKey;
  protected string _localKey;
  protected string _pivotTable;

  this(RelationType type, string foreignModel, string foreignKey, string localKey = "id") {
    super();
    _type = type;
    _foreignModel = foreignModel;
    _foreignKey = foreignKey;
    _localKey = localKey;
  }

  RelationType type() { return _type; }
  string foreignModel() { return _foreignModel; }
  string foreignKey() { return _foreignKey; }
  string localKey() { return _localKey; }
  string pivotTable() { return _pivotTable; }

  void setPivotTable(string table) {
    _pivotTable = table;
  }

  bool isManyToMany() {
    return _type == RelationType.BelongsToMany || _type == RelationType.HasManyThrough;
  }

  bool isOneToOne() {
    return _type == RelationType.HasOne || _type == RelationType.BelongsTo;
  }

  bool isOneToMany() {
    return _type == RelationType.HasMany;
  }
}

/**
 * Eager loader for relationships
 */
class RelationshipLoader : UIMObject {
  protected IDatabase _database;
  protected Relationship _relationship;

  this(IDatabase database, Relationship relationship) {
    super();
    _database = database;
    _relationship = relationship;
  }

  void load(IEntity[] entities, void delegate(bool success, IEntity[] results) @safe callback) @trusted {
    if (entities.length == 0) {
      callback(true, entities);
      return;
    }

    // Extract keys from entities
    string[] keys;
    foreach (entity; entities) {
      keys ~= entity.getAttribute(_relationship.localKey());
    }

    // Build query for related entities
    if (_relationship.isManyToMany()) {
      // Load through pivot table
      // Implementation continues...
    } else {
      // Load directly
      // Implementation continues...
    }
  }
}
