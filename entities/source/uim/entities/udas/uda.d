/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.udas.uda;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * Helper to check if a type has Entity UDA
 */
template hasEntityAttribute(T) {
    enum hasEntityAttribute = hasUDA!(T, UseEntity);
}

/**
 * Helper to get entity table name
 */
template getEntityTableName(T) {
    static if (hasEntityAttribute!T) {
        alias udas = getUDAs!(T, UseEntity);
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
 * Helper to check if a field has UniqueField UDA
 */
template isUnique(alias field) {
    enum isUnique = hasUDA!(field, UniqueField);
}

/**
 * Helper to check if a field has ReadOnly UDA
 */
template isReadOnly(alias field) {
    enum isReadOnly = hasUDA!(field, ReadOnly);
}

unittest {
    writeln("Testing entity attribute UDAs...");
    
    @UseEntity("users")
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
