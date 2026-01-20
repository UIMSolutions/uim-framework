/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphql.types;

import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.variant;
import std.json;

@safe:

/**
 * GraphQL Value type - can hold any JSON-compatible value
 */
alias GraphQLValue = JSONValue;

/**
 * GraphQL type kinds
 */
enum GraphQLTypeKind {
    SCALAR,
    OBJECT,
    INTERFACE,
    UNION,
    ENUM,
    INPUT_OBJECT,
    LIST,
    NON_NULL
}

/**
 * Base class for all GraphQL types
 */
abstract class GraphQLType {
    string name;
    string description;
    
    this(string name, string description = "") pure nothrow @safe {
        this.name = name;
        this.description = description;
    }
    
    abstract GraphQLTypeKind kind() const pure nothrow @safe;
    
    override string toString() const {
        return name;
    }
}

/**
 * Scalar types (Int, Float, String, Boolean, ID)
 */
class GraphQLScalarType : GraphQLType {
    alias SerializeFunc = GraphQLValue function(GraphQLValue) @safe;
    alias ParseFunc = GraphQLValue function(GraphQLValue) @safe;
    
    SerializeFunc serialize;
    ParseFunc parseValue;
    ParseFunc parseLiteral;
    
    this(string name, string description = "") pure nothrow @safe {
        super(name, description);
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.SCALAR;
    }
}

/**
 * Field definition
 */
class GraphQLField {
    string name;
    string description;
    GraphQLType type;
    GraphQLArgument[] args;
    GraphQLValue delegate(GraphQLValue source, GraphQLValue[string] args) @safe resolver;
    
    this(string name, GraphQLType type, string description = "") pure nothrow @safe {
        this.name = name;
        this.type = type;
        this.description = description;
    }
    
    void addArgument(GraphQLArgument arg) pure nothrow @safe {
        args ~= arg;
    }
}

/**
 * Argument definition
 */
class GraphQLArgument {
    string name;
    string description;
    GraphQLType type;
    GraphQLValue defaultValue;
    
    this(string name, GraphQLType type, string description = "") pure nothrow @safe {
        this.name = name;
        this.type = type;
        this.description = description;
        this.defaultValue = JSONValue(null);
    }
}

/**
 * Object type
 */
class GraphQLObjectType : GraphQLType {
    GraphQLField[string] fields;
    GraphQLInterfaceType[] interfaces;
    
    this(string name, string description = "") pure nothrow @safe {
        super(name, description);
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.OBJECT;
    }
    
    void addField(GraphQLField field) @safe {
        fields[field.name] = field;
    }
    
    GraphQLField getField(string name) @safe {
        return fields.get(name, null);
    }
    
    void implementInterface(GraphQLInterfaceType iface) pure nothrow @safe {
        interfaces ~= iface;
    }
}

/**
 * Interface type
 */
class GraphQLInterfaceType : GraphQLType {
    GraphQLField[string] fields;
    
    this(string name, string description = "") pure nothrow @safe {
        super(name, description);
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.INTERFACE;
    }
    
    void addField(GraphQLField field) @safe {
        fields[field.name] = field;
    }
}

/**
 * Union type
 */
class GraphQLUnionType : GraphQLType {
    GraphQLObjectType[] types;
    
    this(string name, string description = "") pure nothrow @safe {
        super(name, description);
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.UNION;
    }
    
    void addType(GraphQLObjectType type) pure nothrow @safe {
        types ~= type;
    }
}

/**
 * Enum value
 */
struct GraphQLEnumValue {
    string name;
    string description;
    GraphQLValue value;
    bool isDeprecated;
    string deprecationReason;
}

/**
 * Enum type
 */
class GraphQLEnumType : GraphQLType {
    GraphQLEnumValue[] values;
    
    this(string name, string description = "") pure nothrow @safe {
        super(name, description);
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.ENUM;
    }
    
    void addValue(string name, GraphQLValue value, string description = "") @safe {
        GraphQLEnumValue enumValue;
        enumValue.name = name;
        enumValue.value = value;
        enumValue.description = description;
        values ~= enumValue;
    }
}

/**
 * Input object type
 */
class GraphQLInputObjectType : GraphQLType {
    GraphQLInputField[string] fields;
    
    this(string name, string description = "") pure nothrow @safe {
        super(name, description);
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.INPUT_OBJECT;
    }
    
    void addField(GraphQLInputField field) @safe {
        fields[field.name] = field;
    }
}

/**
 * Input field definition
 */
class GraphQLInputField {
    string name;
    string description;
    GraphQLType type;
    GraphQLValue defaultValue;
    
    this(string name, GraphQLType type, string description = "") pure nothrow @safe {
        this.name = name;
        this.type = type;
        this.description = description;
        this.defaultValue = JSONValue(null);
    }
}

/**
 * List type wrapper
 */
class GraphQLListType : GraphQLType {
    GraphQLType ofType;
    
    this(GraphQLType ofType) pure nothrow @safe {
        super("[" ~ ofType.name ~ "]");
        this.ofType = ofType;
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.LIST;
    }
}

/**
 * Non-null type wrapper
 */
class GraphQLNonNullType : GraphQLType {
    GraphQLType ofType;
    
    this(GraphQLType ofType) pure nothrow @safe {
        super(ofType.name ~ "!");
        this.ofType = ofType;
    }
    
    override GraphQLTypeKind kind() const pure nothrow @safe {
        return GraphQLTypeKind.NON_NULL;
    }
}

// Built-in scalar types

private GraphQLValue identitySerialize(GraphQLValue v) @safe {
    return v;
}

private GraphQLValue intSerialize(GraphQLValue v) @safe {
    if (v.type == JSONType.integer) return v;
    if (v.type == JSONType.float_) return JSONValue(cast(long)v.floating);
    return JSONValue(null);
}

private GraphQLValue floatSerialize(GraphQLValue v) @safe {
    if (v.type == JSONType.float_) return v;
    if (v.type == JSONType.integer) return JSONValue(cast(double)v.integer);
    return JSONValue(null);
}

private GraphQLValue stringSerialize(GraphQLValue v) @safe {
    if (v.type == JSONType.string) return v;
    return JSONValue(v.toString());
}

private GraphQLValue boolSerialize(GraphQLValue v) @safe {
    if (v.type == JSONType.true_ || v.type == JSONType.false_) return v;
    return JSONValue(null);
}

__gshared GraphQLScalarType GraphQLInt;
__gshared GraphQLScalarType GraphQLFloat;
__gshared GraphQLScalarType GraphQLString;
__gshared GraphQLScalarType GraphQLBoolean;
__gshared GraphQLScalarType GraphQLID;

shared static this() @trusted {
    GraphQLInt = new GraphQLScalarType("Int", "The Int scalar type represents non-fractional signed whole numeric values.");
    GraphQLInt.serialize = &intSerialize;
    GraphQLInt.parseValue = &intSerialize;
    GraphQLInt.parseLiteral = &intSerialize;
    
    GraphQLFloat = new GraphQLScalarType("Float", "The Float scalar type represents signed double-precision fractional values.");
    GraphQLFloat.serialize = &floatSerialize;
    GraphQLFloat.parseValue = &floatSerialize;
    GraphQLFloat.parseLiteral = &floatSerialize;
    
    GraphQLString = new GraphQLScalarType("String", "The String scalar type represents textual data.");
    GraphQLString.serialize = &stringSerialize;
    GraphQLString.parseValue = &stringSerialize;
    GraphQLString.parseLiteral = &stringSerialize;
    
    GraphQLBoolean = new GraphQLScalarType("Boolean", "The Boolean scalar type represents true or false.");
    GraphQLBoolean.serialize = &boolSerialize;
    GraphQLBoolean.parseValue = &boolSerialize;
    GraphQLBoolean.parseLiteral = &boolSerialize;
    
    GraphQLID = new GraphQLScalarType("ID", "The ID scalar type represents a unique identifier.");
    GraphQLID.serialize = &stringSerialize;
    GraphQLID.parseValue = &stringSerialize;
    GraphQLID.parseLiteral = &stringSerialize;
}

/**
 * Helper functions to create type wrappers
 */
GraphQLListType listOf(GraphQLType type) @safe {
    return new GraphQLListType(type);
}

GraphQLNonNullType nonNull(GraphQLType type) @safe {
    return new GraphQLNonNullType(type);
}
