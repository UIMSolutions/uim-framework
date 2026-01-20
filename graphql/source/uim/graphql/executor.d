/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphql.executor;

import uim.graphql;

@safe:

/**
 * Execution context
 */
class ExecutionContext {
    GraphQLSchema schema;
    Json rootValue;
    Json[string] variables;
    FragmentDefinitionNode[string] fragments;
    
    this(GraphQLSchema schema, Json rootValue = Json(null), Json[string] variables = null) pure nothrow @safe {
        this.schema = schema;
        this.rootValue = rootValue;
        this.variables = variables;
    }
}

/**
 * Execution result
 */
struct ExecutionResult {
    Json data;
    string[] errors;
    
    bool hasErrors() const pure nothrow @safe {
        return errors.length > 0;
    }
    
    Json toJSON() const @trusted {
        Json result;
        result["data"] = data;
        if (hasErrors()) {
            Json[] errorArray;
            foreach (err; errors) {
                Json errorObj;
                errorObj["message"] = Json(err);
                errorArray ~= errorObj;
            }
            result["errors"] = Json(errorArray);
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
    ExecutionResult execute(string query, Json rootValue = Json(null), Json[string] variables = null) @safe {
        ExecutionResult result;
        result.data = Json(null);
        
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
    
    private Json executeOperation(ExecutionContext context, OperationDefinitionNode operation, Json rootValue) @safe {
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
    
    private Json executeSelectionSet(ExecutionContext context, SelectionSetNode selectionSet, GraphQLObjectType parentType, Json source) @safe {
        if (selectionSet is null) {
            return Json(null);
        }
        
        Json[string] result;
        
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
        
        return Json(result);
    }
    
    private Json executeField(ExecutionContext context, GraphQLField fieldDef, FieldNode field, GraphQLObjectType parentType, Json source) @safe {
        // Resolve arguments
        Json[string] args;
        foreach (arg; field.arguments) {
            args[arg.name] = resolveArgumentValue(context, arg.value);
        }
        
        // Call resolver
        Json resolvedValue;
        if (fieldDef.resolver !is null) {
            resolvedValue = fieldDef.resolver(source, args);
        } else {
            // Default resolver: try to get field from source object
            if (source.isObject) {
                resolvedValue = () @trusted { 
                    if (field.name in source) {
                        return source[field.name];
                    }
                    return Json(null);
                }();
            } else {
                resolvedValue = Json(null);
            }
        }
        
        // Execute sub-selections
        if (field.selectionSet !is null) {
            auto fieldType = unwrapType(fieldDef.type);
            if (auto objectType = cast(GraphQLObjectType)fieldType) {
                if (resolvedValue.isArray) {
                    // Handle lists
                    Json[] resultArray;
                    foreach (item; () @trusted { return resolvedValue.get!(Json[]); }()) {
                        resultArray ~= executeSelectionSet(context, field.selectionSet, objectType, item);
                    }
                    return Json(resultArray);
                } else {
                    return executeSelectionSet(context, field.selectionSet, objectType, resolvedValue);
                }
            }
        }
        
        return resolvedValue;
    }
    
    private Json resolveArgumentValue(ExecutionContext context, Json value) @safe {
        if (value.isString && value.get!string.startsWith("$")) {
            // Variable reference
            string varName = value.get!string[1 .. $];
            if (varName in context.variables) {
                return context.variables[varName];
            }
            return Json(null);
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
ExecutionResult executeGraphQL(GraphQLSchema schema, string query, Json rootValue = Json(null), Json[string] variables = null) @safe {
    auto executor = new GraphQLExecutor(schema);
    return executor.execute(query, rootValue, variables);
}
