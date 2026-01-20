/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module sql.examples.query_builder;

import uim.sql;
import std.stdio;

void main() {
    writeln("=== UIM SQL Query Builder Examples ===\n");

    // Example 1: Basic SELECT
    writeln("--- Example 1: Basic SELECT ---");
    auto query1 = QueryBuilder.create()
        .select("id", "name", "email")
        .from("users");
    writeln(query1.toSql());
    writeln();

    // Example 2: SELECT with WHERE
    writeln("--- Example 2: SELECT with WHERE ---");
    auto query2 = QueryBuilder.create()
        .select("*")
        .from("products")
        .where("price", ">", SqlValue(100))
        .where("in_stock", "=", SqlValue(true));
    writeln(query2.toSql());
    writeln();

    // Example 3: SELECT with JOIN
    writeln("--- Example 3: SELECT with JOIN ---");
    auto query3 = QueryBuilder.create()
        .select("u.name", "o.order_date", "o.total")
        .from("users u")
        .leftJoin("orders o", "u.id = o.user_id")
        .where("o.status", "=", SqlValue("completed"));
    writeln(query3.toSql());
    writeln();

    // Example 4: SELECT with GROUP BY and HAVING
    writeln("--- Example 4: SELECT with GROUP BY and HAVING ---");
    auto query4 = QueryBuilder.create()
        .select("category", "COUNT(*) as count", "AVG(price) as avg_price")
        .from("products")
        .groupBy("category")
        .having("COUNT(*) > 5")
        .orderBy("count", SortOrder.DESC);
    writeln(query4.toSql());
    writeln();

    // Example 5: INSERT
    writeln("--- Example 5: INSERT ---");
    auto query5 = QueryBuilder.create()
        .insert("users")
        .values([
            "name": SqlValue("John Doe"),
            "email": SqlValue("john@example.com"),
            "age": SqlValue(30)
        ]);
    writeln(query5.toSql());
    writeln();

    // Example 6: UPDATE
    writeln("--- Example 6: UPDATE ---");
    auto query6 = QueryBuilder.create()
        .update("users")
        .set("last_login", SqlValue("2026-01-20"))
        .set("login_count", SqlValue(5))
        .where("id", "=", SqlValue(123));
    writeln(query6.toSql());
    writeln();

    // Example 7: DELETE
    writeln("--- Example 7: DELETE ---");
    auto query7 = QueryBuilder.create()
        .delete_()
        .from("logs")
        .where("created_at", "<", SqlValue("2025-01-01"));
    writeln(query7.toSql());
    writeln();

    // Example 8: Complex WHERE with OR
    writeln("--- Example 8: Complex WHERE ---");
    auto query8 = QueryBuilder.create()
        .select("*")
        .from("users")
        .where("status", "=", SqlValue("active"))
        .andWhere("age", ">=", SqlValue(18))
        .orWhere("is_vip", "=", SqlValue(true));
    writeln(query8.toSql());
    writeln();

    // Example 9: WHERE IN
    writeln("--- Example 9: WHERE IN ---");
    auto query9 = QueryBuilder.create()
        .select("*")
        .from("products")
        .whereIn("category_id", [SqlValue(1), SqlValue(2), SqlValue(3)]);
    writeln(query9.toSql());
    writeln();

    // Example 10: NULL checks
    writeln("--- Example 10: NULL checks ---");
    auto query10 = QueryBuilder.create()
        .select("*")
        .from("users")
        .whereNotNull("email")
        .whereNull("deleted_at");
    writeln(query10.toSql());
    writeln();
}
