/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.plist.value;

import uim.plist.exceptions;
import std.datetime;
import std.conv;
import std.base64;

@safe:

/**
 * Enum representing the type of a property list value
 */
enum PlistType {
    String,      /// String value
    Integer,     /// Integer value
    Float,       /// Floating point value
    Boolean,     /// Boolean value
    Date,        /// Date/time value
    Data,        /// Binary data (base64 encoded)
    Array,       /// Array of values
    Dict         /// Dictionary of key-value pairs
}

/**
 * Structure representing a property list value with type information
 * 
 * This is the fundamental building block for property lists, supporting
 * multiple data types in a type-safe manner.
 */
struct PlistValue {
    private PlistType _type;
    private string _stringValue;
    private long _intValue;
    private double _floatValue;
    private bool _boolValue;
    private SysTime _dateValue;
    private ubyte[] _dataValue;
    private PlistValue[] _arrayValue;
    private PlistValue[string] _dictValue;

    /**
     * Constructor for string values
     */
    this(string value) {
        _type = PlistType.String;
        _stringValue = value;
    }

    /**
     * Constructor for integer values
     */
    this(long value) {
        _type = PlistType.Integer;
        _intValue = value;
    }

    /**
     * Constructor for integer values (int overload)
     */
    this(int value) {
        _type = PlistType.Integer;
        _intValue = value;
    }

    /**
     * Constructor for floating point values
     */
    this(double value) {
        _type = PlistType.Float;
        _floatValue = value;
    }

    /**
     * Constructor for boolean values
     */
    this(bool value) {
        _type = PlistType.Boolean;
        _boolValue = value;
    }

    /**
     * Constructor for date values
     */
    this(SysTime value) {
        _type = PlistType.Date;
        _dateValue = value;
    }

    /**
     * Constructor for binary data values
     */
    this(ubyte[] value) {
        _type = PlistType.Data;
        _dataValue = value.dup;
    }

    /**
     * Constructor for array values
     */
    this(PlistValue[] value) {
        _type = PlistType.Array;
        _arrayValue = value.dup;
    }

    /**
     * Constructor for dictionary values
     */
    this(PlistValue[string] value) {
        _type = PlistType.Dict;
        _dictValue = value.dup;
    }

    /**
     * Gets the type of this value
     */
    @property PlistType type() const {
        return _type;
    }

    /**
     * Converts this value to a string
     */
    string asString() const {
        switch (_type) {
            case PlistType.String:
                return _stringValue;
            case PlistType.Integer:
                return _intValue.to!string;
            case PlistType.Float:
                return _floatValue.to!string;
            case PlistType.Boolean:
                return _boolValue.to!string;
            case PlistType.Date:
                return _dateValue.toISOExtString();
            case PlistType.Data:
                return Base64.encode(_dataValue);
            default:
                throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to string");
        }
    }

    /**
     * Converts this value to an integer
     */
    long asInt() const {
        switch (_type) {
            case PlistType.Integer:
                return _intValue;
            case PlistType.Float:
                return cast(long)_floatValue;
            case PlistType.String:
                return _stringValue.to!long;
            case PlistType.Boolean:
                return _boolValue ? 1 : 0;
            default:
                throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to integer");
        }
    }

    /**
     * Converts this value to a floating point number
     */
    double asFloat() const {
        switch (_type) {
            case PlistType.Float:
                return _floatValue;
            case PlistType.Integer:
                return cast(double)_intValue;
            case PlistType.String:
                return _stringValue.to!double;
            default:
                throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to float");
        }
    }

    /**
     * Converts this value to a boolean
     */
    bool asBool() const {
        switch (_type) {
            case PlistType.Boolean:
                return _boolValue;
            case PlistType.Integer:
                return _intValue != 0;
            case PlistType.String:
                return _stringValue == "true" || _stringValue == "yes" || _stringValue == "1";
            default:
                throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to boolean");
        }
    }

    /**
     * Converts this value to a date
     */
    SysTime asDate() const {
        if (_type == PlistType.Date) {
            return _dateValue;
        }
        if (_type == PlistType.String) {
            return SysTime.fromISOExtString(_stringValue);
        }
        throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to date");
    }

    /**
     * Converts this value to binary data
     */
    ubyte[] asData() const {
        if (_type == PlistType.Data) {
            return _dataValue.dup;
        }
        if (_type == PlistType.String) {
            return Base64.decode(_stringValue);
        }
        throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to data");
    }

    /**
     * Converts this value to an array
     */
    PlistValue[] asArray() const {
        if (_type == PlistType.Array) {
            return _arrayValue.dup;
        }
        throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to array");
    }

    /**
     * Converts this value to a dictionary
     */
    PlistValue[string] asDict() const {
        if (_type == PlistType.Dict) {
            return _dictValue.dup;
        }
        throw new PlistTypeException("Cannot convert " ~ _type.to!string ~ " to dictionary");
    }

    /**
     * Checks if this value is of the specified type
     */
    bool isType(PlistType type) const {
        return _type == type;
    }

    /**
     * String representation for debugging
     */
    string toString() const {
        try {
            return asString();
        } catch (Exception) {
            return "<" ~ _type.to!string ~ ">";
        }
    }
}

// Unit tests
unittest {
    // Test string value
    auto strVal = PlistValue("hello");
    assert(strVal.type == PlistType.String);
    assert(strVal.asString() == "hello");

    // Test integer value
    auto intVal = PlistValue(42);
    assert(intVal.type == PlistType.Integer);
    assert(intVal.asInt() == 42);
    assert(intVal.asString() == "42");

    // Test boolean value
    auto boolVal = PlistValue(true);
    assert(boolVal.type == PlistType.Boolean);
    assert(boolVal.asBool() == true);

    // Test array value
    auto arr = [PlistValue("a"), PlistValue("b"), PlistValue("c")];
    auto arrVal = PlistValue(arr);
    assert(arrVal.type == PlistType.Array);
    assert(arrVal.asArray().length == 3);
}
