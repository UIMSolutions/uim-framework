/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.attributes;

import uim.core;
import std.traits;

@safe:

/**
 * UDA to mark a field as an entity attribute
 */
struct EntityAttribute {
    string name;
    bool required = false;
    
    this(string fieldName) {
        name = fieldName;
    }
    
    this(string fieldName, bool isRequired) {
        name = fieldName;
        required = isRequired;
    }
}

/**
 * UDA to mark a field as required
 */
struct Required {
}

/**
 * UDA to mark a field as unique
 */
struct Unique {
}

/**
 * UDA to mark a field with maximum length validation
 */
struct MaxLength {
    size_t value;
    
    this(size_t len) {
        value = len;
    }
}

/**
 * UDA to mark a field with minimum length validation
 */
struct MinLength {
    size_t value;
    
    this(size_t len) {
        value = len;
    }
}

/**
 * UDA to mark a field with pattern validation (regex)
 */
struct Pattern {
    string regex;
    
    this(string pattern) {
        regex = pattern;
    }
}

/**
 * UDA to mark a field with range validation
 */
struct Range {
    long min;
    long max;
    
    this(long minimum, long maximum) {
        min = minimum;
        max = maximum;
    }
}

/**
 * UDA to mark a field as readonly (cannot be modified after creation)
 */
struct ReadOnly {
}

/**
 * UDA to mark an entity class
 */
struct Entity {
    string tableName;
    
    this(string table = "") {
        tableName = table;
    }
}

/**
 * Helper to check if a type has Entity UDA
 */
template hasEntityAttribute(T) {
    enum hasEntityAttribute = hasUDA!(T, Entity);
}

/**
 * Helper to get entity table name
 */
template getEntityTableName(T) {
    static if (hasEntityAttribute!T) {
        alias udas = getUDAs!(T, Entity);
        static if (udas.length > 0 && udas[0].tableName.length > 0) {
            enum getEntityTableName = udas[0].tableName;
        } else {
            enum getEntityTableName = T.stringof;
        }
    } else {
        enum getEntityTableName = "";
    }
}

/**
 * Helper to check if a field has Required UDA
 */
template isRequired(alias field) {
    enum isRequired = hasUDA!(field, Required);
}

/**
 * Helper to check if a field has Unique UDA
 */
template isUnique(alias field) {
    enum isUnique = hasUDA!(field, Unique);
}

/**
 * Helper to check if a field has ReadOnly UDA
 */
template isReadOnly(alias field) {
    enum isReadOnly = hasUDA!(field, ReadOnly);
}

unittest {
    writeln("Testing entity attribute UDAs...");
    
    @Entity("users")
    class User {
        @Required
        @MaxLength(100)
        string username;
        
        @Required
        @Pattern(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        string email;
        
        @MinLength(8)
        string password;
        
        @Range(0, 150)
        int age;
    }
    
    assert(hasEntityAttribute!User);
    assert(getEntityTableName!User == "users");
    
    writeln("✓ Entity attribute UDAs tests passed!");
}
