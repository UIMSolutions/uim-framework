/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphql.executor;

import std.string;
import std.array;
import std.algorithm;
import std.json;
import std.conv;
import uim.graphql.types;
import uim.graphql.schema;
import uim.graphql.parser;

@safe:

/**
 * Execution context
 */
class ExecutionContext {
    GraphQLSchema schema;
    JSONValue rootValue;
    JSONValue[string] variables;
    FragmentDefinitionNode[string] fragments;
    
    this(GraphQLSchema schema, JSONValue rootValue = JSONValue(null), JSONValue[string] variables = null) pure nothrow @safe {
        this.schema = schema;
        this.rootValue = rootValue;
        this.variables = variables;
    }
}

/**
 * Execution result
 */
struct ExecutionResult {
    JSONValue data;
    string[] errors;
    
    bool hasErrors() const pure nothrow @safe {
        return errors.length > 0;
    }
    
    JSONValue toJSON() const @trusted {
        JSONValue result;
        result["data"] = data;
        if (hasErrors()) {
            JSONValue[] errorArray;
            foreach (err; errors) {
                JSONValue errorObj;
                errorObj["message"] = JSONValue(err);
                errorArray ~= errorObj;
            }
            result["errors"] = JSONValue(errorArray);
        }
        return result;
    }
}

/**
 * GraphQL Executor
 */
class GraphQLExecutor {
    private GraphQLSchema schema;
    
    this(GraphQLSchema schema) pure nothrow @safe {
        this.schema = schema;
    }
    
    /**
     * Execute a GraphQL query
     */
    ExecutionResult execute(string query, JSONValue rootValue = JSONValue(null), JSONValue[string] variables = null) @safe {
        ExecutionResult result;
        result.data = JSONValue(null);
        
        try {
            // Parse the query
            auto document = parseGraphQL(query);
            
            // Create execution context
            auto context = new ExecutionContext(schema, rootValue, variables);
            
            // Collect fragments
            foreach (def; document.definitions) {
                if (auto frag = cast(FragmentDefinitionNode)def) {
                    context.fragments[frag.name] = frag;
                }
            }
            
            // Execute operations
            foreach (def; document.definitions) {
                if (auto op = cast(OperationDefinitionNode)def) {
                    result.data = executeOperation(context, op, rootValue);
                }
            }
        } catch (Exception e) {
            result.errors ~= e.msg;
        }
        
        return result;
    }
    
    private JSONValue executeOperation(ExecutionContext context, OperationDefinitionNode operation, JSONValue rootValue) @safe {
        GraphQLObjectType rootType;
        
        final switch (operation.operation) {
            case OperationType.QUERY:
                rootType = context.schema.queryType;
                break;
            case OperationType.MUTATION:
                rootType = context.schema.mutationType;
                if (rootType is null) {
                    throw new Exception("Schema does not support mutations");
                }
                break;
            case OperationType.SUBSCRIPTION:
                rootType = context.schema.subscriptionType;
                if (rootType is null) {
                    throw new Exception("Schema does not support subscriptions");
                }
                break;
        }
        
        return executeSelectionSet(context, operation.selectionSet, rootType, rootValue);
    }
    
    private JSONValue executeSelectionSet(ExecutionContext context, SelectionSetNode selectionSet, GraphQLObjectType parentType, JSONValue source) @safe {
        if (selectionSet is null) {
            return JSONValue(null);
        }
        
        JSONValue[string] result;
        
        foreach (selection; selectionSet.selections) {
            if (auto field = cast(FieldNode)selection) {
                auto fieldName = field.name;
                auto responseKey = field.aliasName.length > 0 ? field.aliasName : fieldName;
                
                auto fieldDef = parentType.getField(fieldName);
                if (fieldDef is null) {
                    continue; // Skip unknown fields
                }
                
                auto fieldValue = executeField(context, fieldDef, field, parentType, source);
                result[responseKey] = fieldValue;
            }
        }
        
        return JSONValue(result);
    }
    
    private JSONValue executeField(ExecutionContext context, GraphQLField fieldDef, FieldNode field, GraphQLObjectType parentType, JSONValue source) @safe {
        // Resolve arguments
        JSONValue[string] args;
        foreach (arg; field.arguments) {
            args[arg.name] = resolveArgumentValue(context, arg.value);
        }
        
        // Call resolver
        JSONValue resolvedValue;
        if (fieldDef.resolver !is null) {
            resolvedValue = fieldDef.resolver(source, args);
        } else {
            // Default resolver: try to get field from source object
            if (source.type == JSONType.object) {
                resolvedValue = () @trusted { return source.object.get(field.name, JSONValue(null)); }();
            } else {
                resolvedValue = JSONValue(null);
            }
        }
        
        // Execute sub-selections
        if (field.selectionSet !is null) {
            auto fieldType = unwrapType(fieldDef.type);
            if (auto objectType = cast(GraphQLObjectType)fieldType) {
                if (resolvedValue.type == JSONType.array) {
                    // Handle lists
                    JSONValue[] resultArray;
                    foreach (item; () @trusted { return resolvedValue.array; }()) {
                        resultArray ~= executeSelectionSet(context, field.selectionSet, objectType, item);
                    }
                    return JSONValue(resultArray);
                } else {
                    return executeSelectionSet(context, field.selectionSet, objectType, resolvedValue);
                }
            }
        }
        
        return resolvedValue;
    }
    
    private JSONValue resolveArgumentValue(ExecutionContext context, JSONValue value) @safe {
        if (value.type == JSONType.string && value.str.startsWith("$")) {
            // Variable reference
            string varName = value.str[1 .. $];
            return context.variables.get(varName, JSONValue(null));
        }
        return value;
    }
    
    private GraphQLType unwrapType(GraphQLType type) pure nothrow @safe {
        if (auto listType = cast(GraphQLListType)type) {
            return listType.ofType;
        }
        if (auto nonNullType = cast(GraphQLNonNullType)type) {
            return nonNullType.ofType;
        }
        return type;
    }
}

/**
 * Execute a GraphQL query against a schema
 */
ExecutionResult executeGraphQL(GraphQLSchema schema, string query, JSONValue rootValue = JSONValue(null), JSONValue[string] variables = null) @safe {
    auto executor = new GraphQLExecutor(schema);
    return executor.execute(query, rootValue, variables);
}
