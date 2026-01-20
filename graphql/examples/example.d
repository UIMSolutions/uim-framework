/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module graphql.examples.example;

import std.stdio;
import vibe.data.json;
import uim.graphql;

void main() {
    writeln("=== GraphQL Library Example ===\n");

    // Example 1: Build a simple schema
    writeln("1. Building a GraphQL schema:");

    // Define a User type
    auto userType = objectType("User", "A user in the system");
    userType.addField(field("id", GraphQLID, "User ID"));
    userType.addField(field("name", GraphQLString, "User name"));
    userType.addField(field("age", GraphQLInt, "User age"));
    userType.addField(field("email", GraphQLString, "User email"));

    // Define a Post type
    auto postType = objectType("Post", "A blog post");
    postType.addField(field("id", GraphQLID, "Post ID"));
    postType.addField(field("title", GraphQLString, "Post title"));
    postType.addField(field("content", GraphQLString, "Post content"));
    postType.addField(field("authorId", GraphQLID, "Author ID"));

    // Sample data
    Json users = parseJsonString(`[
        {"id": "1", "name": "Alice", "email": "alice@example.com", "age": 30},
        {"id": "2", "name": "Bob", "email": "bob@example.com", "age": 25},
        {"id": "3", "name": "Charlie", "email": "charlie@example.com", "age": 35}
    ]`);

    Json posts = parseJsonString(`[
        {"id": "1", "title": "First Post", "content": "Hello World!", "authorId": "1"},
        {"id": "2", "title": "GraphQL Intro", "content": "Learning GraphQL", "authorId": "1"},
        {"id": "3", "title": "D Language", "content": "D is awesome", "authorId": "2"}
    ]`);

    // Build schema using fluent API
    auto schema = buildSchema()
        .query("Query")
            .field("user", userType, "Get a user by ID")
                .arg("id", nonNull(GraphQLID), "User ID")
                .resolve((source, args) @safe {
                    string userId = args["id"].get!string;
                    foreach (user; users.get!(Json[])) {
                        if (user["id"].get!string == userId) {
                            return user;
                        }
                    }
                    return Json.undefined;
                })
            .field("users", listOf(userType), "Get all users")
                .resolve((source, args) @safe {
                    return users;
                })
            .field("post", postType, "Get a post by ID")
                .arg("id", nonNull(GraphQLID), "Post ID")
                .resolve((source, args) @safe {
                    string postId = args["id"].get!string;
                    foreach (post; posts.get!(Json[])) {
                        if (post["id"].get!string == postId) {
                            return post;
                        }
                    }
                    return Json.undefined;
                })
            .field("posts", listOf(postType), "Get all posts")
                .resolve((source, args) @safe {
                    return posts;
                })
        .build();

    writeln("Schema built successfully!");
    writeln();

    // Example 2: Execute a simple query
    writeln("2. Executing a simple query:");
    string query1 = `{
        user(id: "1") {
            id
            name
            email
        }
    }`;
    writeln("Query:");
    writeln(query1);
    writeln("\nResult:");
    auto result1 = executeGraphQL(schema, query1);
    writeln(result1.toJSON().toPrettyString());
    writeln();

    // Example 3: Query with multiple fields
    writeln("3. Query with multiple fields:");
    string query2 = `{
        users {
            id
            name
            age
        }
    }`;
    writeln("Query:");
    writeln(query2);
    writeln("\nResult:");
    auto result2 = executeGraphQL(schema, query2);
    writeln(result2.toJSON().toPrettyString());
    writeln();

    // Example 4: Query with aliases
    writeln("4. Query with field aliases:");
    string query3 = `{
        alice: user(id: "1") {
            id
            name
        }
        bob: user(id: "2") {
            id
            name
        }
    }`;
    writeln("Query:");
    writeln(query3);
    writeln("\nResult:");
    auto result3 = executeGraphQL(schema, query3);
    writeln(result3.toJSON().toPrettyString());
    writeln();

    // Example 5: Query posts
    writeln("5. Querying posts:");
    string query4 = `{
        posts {
            id
            title
            content
            authorId
        }
    }`;
    writeln("Query:");
    writeln(query4);
    writeln("\nResult:");
    auto result4 = executeGraphQL(schema, query4);
    writeln(result4.toJSON().toPrettyString());
    writeln();

    // Example 6: Query with variables (simulated)
    writeln("6. Query specific post:");
    string query5 = `{
        post(id: "2") {
            id
            title
            content
        }
    }`;
    writeln("Query:");
    writeln(query5);
    writeln("\nResult:");
    auto result5 = executeGraphQL(schema, query5);
    writeln(result5.toJSON().toPrettyString());
    writeln();

    // Example 7: Multiple queries in one request
    writeln("7. Multiple queries in one request:");
    string query6 = `{
        user(id: "1") {
            name
            email
        }
        posts {
            title
        }
    }`;
    writeln("Query:");
    writeln(query6);
    writeln("\nResult:");
    auto result6 = executeGraphQL(schema, query6);
    writeln(result6.toJSON().toPrettyString());
    writeln();

    // Example 8: Schema with mutations
    writeln("8. Building schema with mutations:");
    auto mutationSchema = buildSchema()
        .query("Query")
            .field("users", listOf(userType), "Get all users")
                .resolve((source, args) @safe {
                    return users;
                })
        .mutation("Mutation")
            .field("createUser", userType, "Create a new user")
                .arg("name", nonNull(GraphQLString), "User name")
                .arg("email", nonNull(GraphQLString), "User email")
                .arg("age", GraphQLInt, "User age")
                .resolve((source, args) @safe {
                    // In a real app, this would insert into a database
                    Json newUser = Json([
                        "id" : Json("999"),
                        "name" : args["name"],
                        "email" : args["email"],
                        "age" : args.get("age", Json(0))
                    ]);
                    writeln("  [Simulated] Creating user: ", newUser.toPrettyString());
                    return newUser;
                })
        .build();

    string mutationQuery = `
        mutation {
            createUser(name: "Diana", email: "diana@example.com", age: 28) {
                id
                name
                email
                age
            }
        }
    `;
    writeln("Mutation query:");
    writeln(mutationQuery);
    writeln("\nResult:");
    auto mutationResult = executeGraphQL(mutationSchema, mutationQuery);
    writeln(mutationResult.toJSON().toPrettyString());
    writeln();

    writeln("=== Example Complete ===");
}
