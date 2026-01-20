/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.models.base;

import uim.cdm;
import std.datetime : DateTime, SysTime, Clock;
import std.uuid : UUID, randomUUID;

/**
 * Base class for all CDM models
 */
class CdmModel : UIMObject {
    mixin(ObjThis!("CdmModel"));

    protected UUID _id;
    protected string _name;
    protected string _description;
    protected SysTime _createdAt;
    protected SysTime _modifiedAt;
    protected string _createdBy;
    protected string _modifiedBy;
    protected bool _isActive = true;
    protected Json[string] _customFields;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        _id = randomUUID();
        _createdAt = Clock.currTime();
        _modifiedAt = _createdAt;

        return true;
    }

    // Property getters
    UUID id() const { return _id; }
    string name() const { return _name; }
    string description() const { return _description; }
    SysTime createdAt() const { return _createdAt; }
    SysTime modifiedAt() const { return _modifiedAt; }
    string createdBy() const { return _createdBy; }
    string modifiedBy() const { return _modifiedBy; }
    bool isActive() const { return _isActive; }

    // Property setters (fluent interface)
    auto id(UUID value) { _id = value; return this; }
    auto name(string value) { _name = value; return this; }
    auto description(string value) { _description = value; return this; }
    auto createdBy(string value) { _createdBy = value; return this; }
    auto modifiedBy(string value) { _modifiedBy = value; return this; }
    auto isActive(bool value) { _isActive = value; return this; }

    // Custom fields
    Json getCustomField(string key) const {
        return _customFields.get(key, Json(null));
    }

    auto setCustomField(string key, Json value) {
        _customFields[key] = value;
        return this;
    }

    // Serialization
    Json toJson() const {
        Json result = Json.emptyObject;
        result["id"] = id.toString();
        result["name"] = name;
        result["description"] = description;
        result["createdAt"] = createdAt.toISOExtString();
        result["modifiedAt"] = modifiedAt.toISOExtString();
        result["createdBy"] = createdBy;
        result["modifiedBy"] = modifiedBy;
        result["isActive"] = isActive;
        
        if (_customFields.length > 0) {
            result["customFields"] = Json.emptyObject;
            foreach (key, value; _customFields) {
                result["customFields"][key] = value;
            }
        }
        
        return result;
    }

    // Validation
    bool isValid() const {
        return _name.length > 0;
    }

    string[] validationErrors() const {
        string[] errors;
        if (_name.length == 0) {
            errors ~= "Name is required";
        }
        return errors;
    }

    // Touch modified timestamp
    protected void touch() {
        _modifiedAt = Clock.currTime();
    }
}
