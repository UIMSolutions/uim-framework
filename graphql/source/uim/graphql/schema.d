/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphql.schema;

import std.string;
import std.array;
import std.algorithm;
import std.json;
import uim.graphql.types;

@safe:

/**
 * GraphQL Schema
 */
class GraphQLSchema {
    GraphQLObjectType queryType;
    GraphQLObjectType mutationType;
    GraphQLObjectType subscriptionType;
    
    GraphQLType[string] types;
    GraphQLDirective[string] directives;
    
    this(GraphQLObjectType queryType, GraphQLObjectType mutationType = null, GraphQLObjectType subscriptionType = null) @safe {
        this.queryType = queryType;
        this.mutationType = mutationType;
        this.subscriptionType = subscriptionType;
        
        // Register built-in types
        if (queryType !is null) registerType(queryType);
        if (mutationType !is null) registerType(mutationType);
        if (subscriptionType !is null) registerType(subscriptionType);
    }
    
    void registerType(GraphQLType type) @safe {
        if (type is null) return;
        types[type.name] = type;
        
        // Register related types
        if (auto objType = cast(GraphQLObjectType)type) {
            foreach (field; objType.fields) {
                registerType(field.type);
            }
        } else if (auto listType = cast(GraphQLListType)type) {
            registerType(listType.ofType);
        } else if (auto nonNullType = cast(GraphQLNonNullType)type) {
            registerType(nonNullType.ofType);
        }
    }
    
    GraphQLType getType(string name) @safe {
        return types.get(name, null);
    }
    
    /**
     * Validates the schema
     */
    bool validate(out string[] errors) @safe {
        errors = [];
        
        if (queryType is null) {
            errors ~= "Schema must have a query type";
            return false;
        }
        
        // Validate all object types implement their interfaces correctly
        foreach (type; types) {
            if (auto objType = cast(GraphQLObjectType)type) {
                foreach (iface; objType.interfaces) {
                    foreach (fieldName, ifaceField; iface.fields) {
                        auto objField = objType.getField(fieldName);
                        if (objField is null) {
                            errors ~= "Type " ~ objType.name ~ " must implement field " ~ fieldName ~ " from interface " ~ iface.name;
                        }
                    }
                }
            }
        }
        
        return errors.length == 0;
    }
}

/**
 * Directive location enum
 */
enum DirectiveLocation {
    QUERY,
    MUTATION,
    SUBSCRIPTION,
    FIELD,
    FRAGMENT_DEFINITION,
    FRAGMENT_SPREAD,
    INLINE_FRAGMENT,
    SCHEMA,
    SCALAR,
    OBJECT,
    FIELD_DEFINITION,
    ARGUMENT_DEFINITION,
    INTERFACE,
    UNION,
    ENUM,
    ENUM_VALUE,
    INPUT_OBJECT,
    INPUT_FIELD_DEFINITION
}

/**
 * Directive definition
 */
class GraphQLDirective {
    string name;
    string description;
    DirectiveLocation[] locations;
    GraphQLArgument[] args;
    
    this(string name, DirectiveLocation[] locations, string description = "") pure nothrow @safe {
        this.name = name;
        this.locations = locations;
        this.description = description;
    }
    
    void addArgument(GraphQLArgument arg) pure nothrow @safe {
        args ~= arg;
    }
}
