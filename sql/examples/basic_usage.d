/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module sql.examples.basic_usage;

import uim.sql;
import std.stdio;

void main() {
    writeln("=== UIM SQL Basic Usage Example ===\n");

    // Create connection configuration
    auto config = ConnectionConfig(
        host: "localhost",
        port: 3306,
        database: "test_db",
        username: "user",
        password: "pass",
        dialect: SqlDialect.MYSQL
    );

    // Create and configure connection
    auto conn = Connection.create();
    conn.config = config;

    // Connect to database
    if (conn.connect()) {
        writeln("Connected to database successfully\n");

        // Example 1: Simple query
        writeln("--- Example 1: Simple Query ---");
        auto result = conn.query("SELECT * FROM users WHERE active = ?", [SqlValue(true)]);
        foreach (row; result) {
            writeln("User: ", row["name"].asString);
        }

        // Example 2: Query builder
        writeln("\n--- Example 2: Query Builder ---");
        auto builder = QueryBuilder.create()
            .select("id", "name", "email")
            .from("users")
            .where("age", ">", SqlValue(18))
            .where("active", "=", SqlValue(true))
            .orderBy("name", SortOrder.ASC)
            .limit(10);

        writeln("Generated SQL: ", builder.toSql());
        auto queryResult = conn.execute(builder);

        // Example 3: Prepared statements
        writeln("\n--- Example 3: Prepared Statements ---");
        auto stmt = conn.prepare("SELECT * FROM users WHERE name = ? AND age > ?");
        stmt.bind(1, SqlValue("John"));
        stmt.bind(2, SqlValue(25));
        auto stmtResult = stmt.execute();
        writeln("Found ", stmtResult.rowCount(), " users");

        // Example 4: Transactions
        writeln("\n--- Example 4: Transactions ---");
        auto tx = conn.beginTransaction();
        try {
            conn.execute("INSERT INTO users (name, email) VALUES (?, ?)", 
                [SqlValue("Alice"), SqlValue("alice@example.com")]);
            conn.execute("UPDATE accounts SET balance = balance - 100 WHERE user_id = ?",
                [SqlValue(1)]);
            
            tx.commit();
            writeln("Transaction committed successfully");
        } catch (Exception e) {
            tx.rollback();
            writeln("Transaction rolled back: ", e.msg);
        }

        // Example 5: Complex query with joins
        writeln("\n--- Example 5: Complex Query ---");
        auto complexQuery = QueryBuilder.create()
            .select("u.id", "u.name", "o.total")
            .from("users u")
            .leftJoin("orders o", "u.id = o.user_id")
            .where("u.active", "=", SqlValue(true))
            .groupBy("u.id", "u.name")
            .having("COUNT(o.id) > 0")
            .orderBy("o.total", SortOrder.DESC);

        writeln("Complex SQL: ", complexQuery.toSql());

        // Close connection
        conn.close();
        writeln("\nConnection closed");
    } else {
        writeln("Failed to connect: ", conn.lastError());
    }
}
