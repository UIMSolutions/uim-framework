/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.schemas.field;

import uim.cdm;

/**
 * Schema field definition
 */
class SchemaField : UIMObject {
    mixin(ObjThis!("SchemaField"));

    protected string _name;
    protected FieldType _type;
    protected bool _required;
    protected bool _nullable = true;
    protected Json _defaultValue;
    protected size_t _minLength;
    protected size_t _maxLength;
    protected double _minValue;
    protected double _maxValue;
    protected string _pattern;
    protected string _description;

    this(string name, FieldType type, bool required = false) {
        this();
        _name = name;
        _type = type;
        _required = required;
    }

    // Property getters
    string name() const { return _name; }
    FieldType type() const { return _type; }
    bool required() const { return _required; }
    bool nullable() const { return _nullable; }
    Json defaultValue() const { return _defaultValue; }
    size_t minLength() const { return _minLength; }
    size_t maxLength() const { return _maxLength; }
    double minValue() const { return _minValue; }
    double maxValue() const { return _maxValue; }
    string pattern() const { return _pattern; }
    string description() const { return _description; }

    // Property setters (fluent interface)
    auto nullable(bool value) { _nullable = value; return this; }
    auto defaultValue(Json value) { _defaultValue = value; return this; }
    auto minLength(size_t value) { _minLength = value; return this; }
    auto maxLength(size_t value) { _maxLength = value; return this; }
    auto minValue(double value) { _minValue = value; return this; }
    auto maxValue(double value) { _maxValue = value; return this; }
    auto pattern(string value) { _pattern = value; return this; }
    auto description(string value) { _description = value; return this; }

    Json toJson() const {
        Json result = Json.emptyObject;
        result["name"] = name;
        result["type"] = cast(int)type;
        result["required"] = required;
        result["nullable"] = nullable;
        if (_defaultValue.type != Json.Type.undefined) {
            result["defaultValue"] = defaultValue;
        }
        if (_minLength > 0) result["minLength"] = minLength;
        if (_maxLength > 0) result["maxLength"] = maxLength;
        if (_minValue != double.init) result["minValue"] = minValue;
        if (_maxValue != double.init) result["maxValue"] = maxValue;
        if (_pattern.length > 0) result["pattern"] = pattern;
        if (_description.length > 0) result["description"] = description;
        return result;
    }
}
