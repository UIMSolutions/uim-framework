/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata.entity;

import uim.odata.exceptions;
import std.json;
import std.conv;
import std.datetime;

@safe:

/**
 * ODataEntity - Represents an OData entity
 * 
 * An entity is a single instance from an entity set with properties
 * and optional navigation properties.
 */
class ODataEntity {
    private string _entityType;
    private JSONValue _properties;
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
        _properties = JSONValue.emptyObject;
    }

    /**
     * Constructor with initial data
     */
    this(string entityType, JSONValue data) {
        _entityType = entityType;
        _properties = data;
    }

    /**
     * Sets a property value
     */
    void set(T)(string propertyName, T value) {
        static if (is(T == string)) {
            _properties[propertyName] = JSONValue(value);
        } else static if (is(T == int) || is(T == long)) {
            _properties[propertyName] = JSONValue(cast(long)value);
        } else static if (is(T == double) || is(T == float)) {
            _properties[propertyName] = JSONValue(cast(double)value);
        } else static if (is(T == bool)) {
            _properties[propertyName] = JSONValue(value);
        } else static if (is(T == JSONValue)) {
            _properties[propertyName] = value;
        } else {
            _properties[propertyName] = JSONValue(value.to!string);
        }
    }

    /**
     * Gets a property value as JSON
     */
    JSONValue get(string propertyName) const {
        if (propertyName !in _properties.object) {
            throw new ODataEntityException("Property not found: " ~ propertyName);
        }
        return _properties[propertyName];
    }

    /**
     * Gets a property value as string
     */
    string getString(string propertyName) const {
        auto value = get(propertyName);
        if (value.type == JSONType.string) {
            return value.str;
        }
        return value.toString();
    }

    /**
     * Gets a property value as integer
     */
    long getInt(string propertyName) const {
        auto value = get(propertyName);
        if (value.type == JSONType.integer) {
            return value.integer;
        }
        if (value.type == JSONType.string) {
            return value.str.to!long;
        }
        throw new ODataEntityException("Cannot convert property to integer: " ~ propertyName);
    }

    /**
     * Gets a property value as float
     */
    double getFloat(string propertyName) const {
        auto value = get(propertyName);
        if (value.type == JSONType.float_) {
            return value.floating;
        }
        if (value.type == JSONType.integer) {
            return cast(double)value.integer;
        }
        if (value.type == JSONType.string) {
            return value.str.to!double;
        }
        throw new ODataEntityException("Cannot convert property to float: " ~ propertyName);
    }

    /**
     * Gets a property value as boolean
     */
    bool getBool(string propertyName) const {
        auto value = get(propertyName);
        if (value.type == JSONType.true_) {
            return true;
        }
        if (value.type == JSONType.false_) {
            return false;
        }
        throw new ODataEntityException("Cannot convert property to boolean: " ~ propertyName);
    }

    /**
     * Checks if a property exists
     */
    bool has(string propertyName) const {
        return (propertyName in _properties.object) !is null;
    }

    /**
     * Removes a property
     */
    void remove(string propertyName) {
        _properties.object.remove(propertyName);
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
    string[] propertyNames() const {
        return _properties.object.keys;
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
    JSONValue toJSONValue() const {
        return _properties;
    }

    /**
     * Creates an entity from JSON string
     */
    static ODataEntity fromJSON(string entityType, string jsonStr) {
        auto json = parseJSON(jsonStr);
        return new ODataEntity(entityType, json);
    }

    /**
     * Creates an entity from JSON value
     */
    static ODataEntity fromJSONValue(string entityType, JSONValue json) {
        return new ODataEntity(entityType, json);
    }

    /**
     * Merges properties from another entity
     */
    void merge(ODataEntity other) {
        foreach (key, value; other._properties.object) {
            _properties[key] = value;
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
