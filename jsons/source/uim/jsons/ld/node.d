/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.node;

import uim.jsons;

@safe:

/**
 * JSON-LD node object.
 */
class DJSONLDNode : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _id;
  protected string[] _types;
  protected Json[string] _properties;

  this() {
    super();
  }

  this(string id) {
    this();
    _id = id;
  }

  // Getters
  string id() { return _id; }
  string[] types() { return _types.dup; }

  // Setters
  void id(string value) { _id = value; }

  /**
   * Add a type.
   */
  DJSONLDNode addType(string type) {
    _types ~= type;
    return this;
  }

  /**
   * Set property value.
   */
  DJSONLDNode set(string property, Json value) {
    _properties[property] = value;
    return this;
  }

  /**
   * Set property with string value.
   */
  DJSONLDNode set(string property, string value) {
    return set(property, Json(value));
  }

  /**
   * Set property with integer value.
   */
  DJSONLDNode set(string property, long value) {
    return set(property, Json(value));
  }

  /**
   * Set property with boolean value.
   */
  DJSONLDNode set(string property, bool value) {
    return set(property, Json(value));
  }

  /**
   * Get property value.
   */
  Json get(string property) {
    if (auto value = property in _properties) {
      return *value;
    }
    return Json(null);
  }

  /**
   * Check if property exists.
   */
  bool has(string property) {
    return (property in _properties) !is null;
  }

  /**
   * Get all property names.
   */
  string[] propertyNames() {
    return _properties.keys;
  }

  /**
   * Convert to JSON-LD format.
   */
  Json toJson() {
    auto result = Json.emptyObject;
    
    if (_id.length > 0) {
      result[JSONLDKeywords.id] = _id;
    }
    
    if (_types.length > 0) {
      if (_types.length == 1) {
        result[JSONLDKeywords.type] = _types[0];
      } else {
        Json[] typeArray;
        foreach (type; _types) {
          typeArray ~= Json(type);
        }
        result[JSONLDKeywords.type] = Json(typeArray);
      }
    }
    
    foreach (key, value; _properties) {
      result[key] = value;
    }
    
    return result;
  }

  /**
   * Create from JSON.
   */
  static DJSONLDNode fromJson(Json json) {
    auto node = new DJSONLDNode();
    
    if (json.type != Json.Type.object) {
      throw new InvalidDocumentException("Node must be an object");
    }
    
    auto obj = json.get!(Json[string]);
    
    // Extract @id
    if (auto idValue = JSONLDKeywords.id in obj) {
      node._id = idValue.get!string;
    }
    
    // Extract @type
    if (auto typeValue = JSONLDKeywords.type in obj) {
      if (typeValue.type == Json.Type.string) {
        node._types ~= typeValue.get!string;
      } else if (typeValue.type == Json.Type.array) {
        foreach (t; typeValue.get!(Json[])) {
          node._types ~= t.get!string;
        }
      }
    }
    
    // Extract properties
    foreach (key, value; obj) {
      if (key != JSONLDKeywords.id && key != JSONLDKeywords.type) {
        node._properties[key] = value;
      }
    }
    
    return node;
  }
}

unittest {
  auto node = new DJSONLDNode("http://example.com/person/1");
  node.addType("http://schema.org/Person");
  node.set("name", "John Doe");
  node.set("age", 30);
  
  assert(node.id == "http://example.com/person/1");
  assert(node.has("name"));
  assert(node.get("name").get!string == "John Doe");
}
