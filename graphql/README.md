# UIM GraphQL Library

A comprehensive GraphQL query language implementation for D.

## Features

- **Complete Type System**: Scalars, Objects, Interfaces, Unions, Enums, Input Objects, Lists, Non-Null
- **Schema Definition**: Define GraphQL schemas with type safety
- **Query Parser**: Full GraphQL query language parser with lexer and AST
- **Query Executor**: Execute GraphQL queries with resolvers
- **Fluent Builder API**: Build schemas using an intuitive fluent API
- **Built-in Scalars**: Int, Float, String, Boolean, ID
- **Field Arguments**: Support for field arguments with type validation
- **Aliases**: Field aliasing support
- **Mutations**: Support for GraphQL mutations
- **Fragments**: Fragment definitions and spreads
- **Variables**: Query variables support
- **Directives**: Directive definitions (schema-level)

## Installation

Add the dependency in your `dub.sdl`:

```sdl
dependency "uim-base:graphql" version="~>1.0.0"
```

Or in `dub.json`:

```json
{
    "dependencies": {
        "uim-base:graphql": "~>1.0.0"
    }
}
```

## Quick Start

```d
import uim.graphql;
import std.json;

// Define a type
auto userType = objectType("User");
userType.addField(field("id", GraphQLID));
userType.addField(field("name", GraphQLString));
userType.addField(field("email", GraphQLString));

// Build schema
auto schema = buildSchema()
    .query()
        .field("user", userType)
            .arg("id", nonNull(GraphQLID))
            .resolve((source, args) @safe {
                // Your resolver logic here
                return JSONValue(["id": args["id"], "name": JSONValue("Alice")]);
            })
    .build();

// Execute query
string query = `{ user(id: "1") { name email } }`;
auto result = executeGraphQL(schema, query);
writeln(result.toJSON().toPrettyString());
```

## Usage Examples

### Defining Types

```d
// Object type
auto userType = objectType("User", "A user in the system");
userType.addField(field("id", GraphQLID, "User ID"));
userType.addField(field("name", GraphQLString, "User name"));
userType.addField(field("email", GraphQLString, "User email"));
userType.addField(field("age", GraphQLInt, "User age"));

// Enum type
auto roleType = enumType("Role", ["USER", "ADMIN", "MODERATOR"]);

// Input type
auto userInputType = inputObjectType("UserInput");
userInputType.addField(new GraphQLInputField("name", GraphQLString));
userInputType.addField(new GraphQLInputField("email", GraphQLString));

// List type
auto usersListType = listOf(userType);

// Non-null type
auto requiredString = nonNull(GraphQLString);
```

### Building a Schema

```d
auto schema = buildSchema()
    .query("Query")
        .field("user", userType, "Get a user by ID")
            .arg("id", nonNull(GraphQLID), "User ID")
            .resolve((source, args) @safe {
                string userId = args["id"].str;
                // Fetch user from database
                return getUserById(userId);
            })
        .field("users", listOf(userType), "Get all users")
            .resolve((source, args) @safe {
                return getAllUsers();
            })
    .mutation("Mutation")
        .field("createUser", userType, "Create a new user")
            .arg("name", nonNull(GraphQLString))
            .arg("email", nonNull(GraphQLString))
            .arg("age", GraphQLInt)
            .resolve((source, args) @safe {
                return createUser(args["name"].str, args["email"].str);
            })
    .build();
```

### Executing Queries

```d
// Simple query
string query1 = `{
    user(id: "1") {
        id
        name
        email
    }
}`;

auto result1 = executeGraphQL(schema, query1);
writeln(result1.data);

// Query with aliases
string query2 = `{
    alice: user(id: "1") { name }
    bob: user(id: "2") { name }
}`;

auto result2 = executeGraphQL(schema, query2);

// Query with variables
string query3 = `
    query GetUser($userId: ID!) {
        user(id: $userId) {
            name
            email
        }
    }
`;

JSONValue[string] variables = [
    "userId": JSONValue("1")
];

auto result3 = executeGraphQL(schema, query3, JSONValue(null), variables);
```

### Mutations

```d
string mutation = `
    mutation {
        createUser(name: "Alice", email: "alice@example.com", age: 30) {
            id
            name
            email
        }
    }
`;

auto result = executeGraphQL(schema, mutation);
```

### List Queries

```d
string query = `{
    users {
        id
        name
        email
    }
}`;

auto result = executeGraphQL(schema, query);
// Result contains an array of users
```

### Error Handling

```d
auto result = executeGraphQL(schema, query);

if (result.hasErrors()) {
    writeln("Errors:");
    foreach (error; result.errors) {
        writeln("  - ", error);
    }
} else {
    writeln("Data:", result.data);
}

// Get full result as JSON
JSONValue json = result.toJSON();
// {
//   "data": { ... },
//   "errors": [ ... ]  // Only if errors exist
// }
```

### Custom Resolvers

```d
// Simple field resolver
field("name", GraphQLString)
    .withResolver((source, args) @safe {
        return source["firstName"].str ~ " " ~ source["lastName"].str;
    });

// Resolver with database access
field("posts", listOf(postType))
    .withArg("limit", GraphQLInt, "Limit results")
    .withResolver((source, args) @safe {
        int limit = args.get("limit", JSONValue(10)).integer.to!int;
        string userId = source["id"].str;
        return fetchUserPosts(userId, limit);
    });
```

### Nested Queries

```d
// User type with posts
auto userType = objectType("User");
userType.addField(field("id", GraphQLID));
userType.addField(field("name", GraphQLString));
userType.addField(field("posts", listOf(postType))
    .withResolver((source, args) @safe {
        return getPostsByUserId(source["id"].str);
    }));

// Query
string query = `{
    user(id: "1") {
        name
        posts {
            title
            content
        }
    }
}`;
```

## Built-in Types

### Scalar Types

- `GraphQLInt` - Signed 32-bit integer
- `GraphQLFloat` - Signed double-precision floating-point
- `GraphQLString` - UTF-8 character sequence
- `GraphQLBoolean` - true or false
- `GraphQLID` - Unique identifier

### Type Modifiers

- `listOf(type)` - List of the given type
- `nonNull(type)` - Non-nullable version of the given type

## API Reference

### GraphQLSchema

The main schema containing query, mutation, and subscription types.

- `new GraphQLSchema(queryType, mutationType, subscriptionType)`
- `registerType(type)` - Register a type in the schema
- `getType(name)` - Get a type by name
- `validate()` - Validate the schema

### GraphQLObjectType

Represents an object type with fields.

- `addField(field)` - Add a field to the type
- `getField(name)` - Get a field by name
- `implementInterface(interface)` - Implement an interface

### GraphQLField

Represents a field with a type and optional resolver.

- `new GraphQLField(name, type, description)`
- `addArgument(arg)` - Add an argument
- `resolver` - Function to resolve the field value

### Execution

- `executeGraphQL(schema, query, rootValue, variables)` - Execute a query
- `parseGraphQL(query)` - Parse a GraphQL query string

## Examples

See the [examples](examples/) directory for complete working examples:

- `example.d` - Comprehensive examples of all features

Run the example:
```bash
cd examples
dub run
```

## Building and Testing

Build the library:
```bash
dub build
```

Run tests:
```bash
dub test
```

Build documentation:
```bash
dub build --build=docs
```

## Roadmap

Future enhancements:
- [ ] Subscriptions execution
- [ ] Schema introspection
- [ ] Validation of queries against schema
- [ ] Custom scalar types
- [ ] Interface implementation validation
- [ ] Union type resolution
- [ ] Inline fragments
- [ ] Directive execution (@skip, @include)
- [ ] Query complexity analysis
- [ ] DataLoader pattern support

## License

This library is licensed under the Apache License 2.0. See LICENSE.txt for details.

## Author

Ozan Nurettin Süel (UIManufaktur)
