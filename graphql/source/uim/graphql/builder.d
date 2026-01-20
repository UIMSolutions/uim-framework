/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphql.builder;

import std.string;
import std.array;
import std.algorithm;
import std.json;
import uim.graphql.types;
import uim.graphql.schema;

@safe:

/**
 * Fluent builder for GraphQL schemas
 */
class GraphQLSchemaBuilder {
    private GraphQLObjectType queryType;
    private GraphQLObjectType mutationType;
    private GraphQLObjectType subscriptionType;
    private GraphQLObjectType currentObjectType;
    private GraphQLField currentField;
    
    this() pure nothrow @safe {
    }
    
    /**
     * Define the query type
     */
    GraphQLSchemaBuilder query(string name = "Query") return @safe {
        queryType = new GraphQLObjectType(name);
        currentObjectType = queryType;
        return this;
    }
    
    /**
     * Define the mutation type
     */
    GraphQLSchemaBuilder mutation(string name = "Mutation") return @safe {
        mutationType = new GraphQLObjectType(name);
        currentObjectType = mutationType;
        return this;
    }
    
    /**
     * Define the subscription type
     */
    GraphQLSchemaBuilder subscription(string name = "Subscription") return @safe {
        subscriptionType = new GraphQLObjectType(name);
        currentObjectType = subscriptionType;
        return this;
    }
    
    /**
     * Add a field to the current object type
     */
    GraphQLSchemaBuilder field(string name, GraphQLType type, string description = "") return @safe {
        if (currentObjectType is null) {
            query(); // Default to query type
        }
        
        currentField = new GraphQLField(name, type, description);
        currentObjectType.addField(currentField);
        return this;
    }
    
    /**
     * Add a resolver to the current field
     */
    GraphQLSchemaBuilder resolve(GraphQLValue delegate(GraphQLValue source, GraphQLValue[string] args) @safe resolver) return @safe {
        if (currentField !is null) {
            currentField.resolver = resolver;
        }
        return this;
    }
    
    /**
     * Add an argument to the current field
     */
    GraphQLSchemaBuilder arg(string name, GraphQLType type, string description = "") return @safe {
        if (currentField !is null) {
            auto arg = new GraphQLArgument(name, type, description);
            currentField.addArgument(arg);
        }
        return this;
    }
    
    /**
     * Build the schema
     */
    GraphQLSchema build() return @safe {
        if (queryType is null) {
            query(); // Ensure we have at least a query type
        }
        return new GraphQLSchema(queryType, mutationType, subscriptionType);
    }
}

/**
 * Create a new schema builder
 */
GraphQLSchemaBuilder buildSchema() @safe {
    return new GraphQLSchemaBuilder();
}

/**
 * Create an object type
 */
GraphQLObjectType objectType(string name, string description = "") @safe {
    return new GraphQLObjectType(name, description);
}

/**
 * Create an enum type
 */
GraphQLEnumType enumType(string name, string[] values, string description = "") @safe {
    auto enumType = new GraphQLEnumType(name, description);
    foreach (i, value; values) {
        enumType.addValue(value, JSONValue(i));
    }
    return enumType;
}

/**
 * Create an input object type
 */
GraphQLInputObjectType inputObjectType(string name, string description = "") @safe {
    return new GraphQLInputObjectType(name, description);
}

/**
 * Create a union type
 */
GraphQLUnionType unionType(string name, GraphQLObjectType[] types, string description = "") @safe {
    auto union_ = new GraphQLUnionType(name, description);
    foreach (type; types) {
        union_.addType(type);
    }
    return union_;
}

/**
 * Create an interface type
 */
GraphQLInterfaceType interfaceType(string name, string description = "") @safe {
    return new GraphQLInterfaceType(name, description);
}

/**
 * Helper to create a field
 */
GraphQLField field(string name, GraphQLType type, string description = "") @safe {
    return new GraphQLField(name, type, description);
}

/**
 * Helper to add a resolver to a field
 */
GraphQLField withResolver(GraphQLField field, GraphQLValue delegate(GraphQLValue, GraphQLValue[string]) @safe resolver) @safe {
    field.resolver = resolver;
    return field;
}

/**
 * Helper to add an argument to a field
 */
GraphQLField withArg(GraphQLField field, string name, GraphQLType type, string description = "") @safe {
    auto arg = new GraphQLArgument(name, type, description);
    field.addArgument(arg);
    return field;
}
