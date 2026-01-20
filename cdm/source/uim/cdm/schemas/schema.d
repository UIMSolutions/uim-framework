/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.schemas.schema;

import uim.cdm;

/**
 * Schema definition for data models
 */
class Schema : UIMObject {
    mixin(ObjThis!("Schema"));

    protected string _name;
    protected string _description;
    protected string _version;
    protected SchemaField[string] _fields;

    this(string name) {
        this();
        _name = name;
        _version = "1.0";
    }

    // Property getters
    string name() const { return _name; }
    string description() const { return _description; }
    string schemaVersion() const { return _version; }
    const(SchemaField[string]) fields() const { return _fields; }

    // Property setters (fluent interface)
    auto description(string value) { _description = value; return this; }
    auto schemaVersion(string value) { _version = value; return this; }

    // Field management
    auto addField(string name, FieldType type, bool required = false) {
        auto field = new SchemaField(name, type, required);
        _fields[name] = field;
        return this;
    }

    auto addField(SchemaField field) {
        _fields[field.name] = field;
        return this;
    }

    SchemaField getField(string name) {
        return _fields.get(name, null);
    }

    bool hasField(string name) const {
        return (name in _fields) !is null;
    }

    auto removeField(string name) {
        _fields.remove(name);
        return this;
    }

    Json toJson() const {
        Json result = Json.emptyObject;
        result["name"] = name;
        result["description"] = description;
        result["version"] = schemaVersion;
        result["fields"] = Json.emptyArray;
        
        foreach (field; _fields) {
            result["fields"] ~= field.toJson();
        }
        
        return result;
    }
}
