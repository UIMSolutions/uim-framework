/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata.entity;

import uim.odata;

@safe:

/**
 * ODataEntity - Represents an OData entity
 * 
 * An entity is a single instance from an entity set with properties
 * and optional navigation properties.
 */
class ODataEntity {
  private string _entityType;
  private Json _properties;
  private string _id;
  private string _etag;

  /**
     * Constructor
     * 
     * Params:
     *   entityType = The entity type name (e.g., "Product", "Customer")
     */
  this(string entityType) {
    _entityType = entityType;
    _properties = Json.emptyObject;
  }

  /**
     * Constructor with initial data
     */
  this(string entityType, Json data) {
    _entityType = entityType;
    _properties = data;
  }

  /**
     * Sets a property value
     */
  void set(T)(string propertyName, T value) {
    static if (is(T == string)) {
      _properties[propertyName] = Json(value);
    } else static if (is(T == int) || is(T == long)) {
      _properties[propertyName] = Json(value);
    } else static if (is(T == double) || is(T == float)) {
      _properties[propertyName] = Json(value);
    } else static if (is(T == bool)) {
      _properties[propertyName] = Json(value);
    } else static if (is(T == Json)) {
      _properties[propertyName] = value;
    } else {
      _properties[propertyName] = value.toJson;
    }
  }

  /**
     * Gets a property value as JSON
     */
  Json get(string propertyName) const @trusted {
    if (propertyName !in _properties) {
      throw new ODataEntityException("Property not found: " ~ propertyName);
    }
    return _properties[propertyName];
  }

  /**
     * Gets a property value as string
     */
  string getString(string propertyName) const {
    auto value = get(propertyName);
    if (value.isString) {
      return value.get!string;
    }
    return value.toString();
  }

  /**
     * Gets a property value as integer
     */
  long getInt(string propertyName) const {
    auto value = get(propertyName);
    if (value.isInteger) {
      return value.get!long;
    }
    if (value.isString) {
      return value.get!string
        .to!long;
    }
    throw new ODataEntityException("Cannot convert property to integer: " ~ propertyName);
  }

  /**
     * Gets a property value as float
     */
  double getFloat(string propertyName) const {
    auto value = get(propertyName);
    if (value.isDouble) {
      return value.get!double;
    }
    if (value.isInteger) {
      return cast(double)value.get!long;
    }
    if (value.isString) {
      return value.get!string
        .to!double;
    }
    throw new ODataEntityException("Cannot convert property to float: " ~ propertyName);
  }

  /**
     * Gets a property value as boolean
     */
  bool getBool(string propertyName) const {
    auto value = get(propertyName);
    if (value.isBoolean) {
      return value.get!bool;
    }
    throw new ODataEntityException("Cannot convert property to boolean: " ~ propertyName);
  }

  /**
     * Checks if a property exists
     */
  bool has(string propertyName) const @trusted {
    return (propertyName in _properties) ? true : false;
  }

  /**
     * Removes a property
     */
  void remove(string propertyName) @trusted {
    _properties.remove(propertyName);
  }

  /**
     * Gets the entity type
     */
  @property string entityType() const {
    return _entityType;
  }

  /**
     * Sets the entity ID
     */
  @property void id(string value) {
    _id = value;
  }

  /**
     * Gets the entity ID
     */
  @property string id() const {
    return _id;
  }

  /**
     * Sets the ETag
     */
  @property void etag(string value) {
    _etag = value;
  }

  /**
     * Gets the ETag
     */
  @property string etag() const {
    return _etag;
  }

  /**
     * Gets all property names
     */
  string[] propertyNames() const @trusted {
    return _properties.toMap.byKeyValue.map!(kv => kv.key).array;
  }

  /**
     * Converts the entity to JSON format
     */
  string toJSON() const {
    return _properties.toPrettyString();
  }

  /**
     * Gets the raw JSON value
     */
  Json toJson() const {
    return _properties;
  }

  /**
     * Creates an entity from JSON string
     */
  static ODataEntity fromJSON(string entityType, string jsonStr) {
    auto json = parseJsonString(jsonStr);
    return new ODataEntity(entityType, json);
  }

  /**
     * Creates an entity from JSON value
     */
  static ODataEntity fromJson(string entityType, Json json) {
    return new ODataEntity(entityType, json);
  }

  /**
     * Merges properties from another entity
     */
  void merge(ODataEntity other) @trusted {
    foreach (kv; other._properties.byKeyValue) {
      _properties[kv.key] = kv.value;
    }
  }

  /**
     * Creates a copy of this entity
     */
  ODataEntity clone() const {
    auto copy = new ODataEntity(_entityType, _properties);
    copy._id = _id;
    copy._etag = _etag;
    return copy;
  }
}

// Unit tests
unittest {
  auto entity = new ODataEntity("Product");
  entity.set("ProductID", 1);
  entity.set("ProductName", "Chai");
  entity.set("UnitPrice", 18.0);

  assert(entity.has("ProductID"));
  assert(entity.getInt("ProductID") == 1);
  assert(entity.getString("ProductName") == "Chai");
  assert(entity.getFloat("UnitPrice") == 18.0);
}

unittest {
  auto entity = new ODataEntity("Customer");
  entity.set("Name", "John");
  entity.set("Active", true);

  auto json = entity.toJSON();
  assert(json.length > 0);

  auto loaded = ODataEntity.fromJSON("Customer", json);
  assert(loaded.getString("Name") == "John");
  assert(loaded.getBool("Active") == true);
}

unittest {
  auto entity1 = new ODataEntity("Product");
  entity1.set("ID", 1);
  entity1.set("Name", "A");

  auto entity2 = new ODataEntity("Product");
  entity2.set("Name", "B");
  entity2.set("Price", 10.0);

  entity1.merge(entity2);

  assert(entity1.getString("Name") == "B");
  assert(entity1.has("Price"));
}
