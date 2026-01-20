/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module sql.tests.test_querybuilder;

import uim.sql;
import std.stdio;

@safe:

void testBasicSelect() {
    writeln("Testing basic SELECT...");
    auto query = QueryBuilder.create()
        .select("id", "name")
        .from("users");
    
    assert(query.toSql() == "SELECT id, name FROM users");
    writeln("✓ Basic SELECT test passed");
}

void testSelectWithWhere() {
    writeln("Testing SELECT with WHERE...");
    auto query = QueryBuilder.create()
        .select("*")
        .from("products")
        .where("price", ">", SqlValue(100));
    
    auto sql = query.toSql();
    assert(sql == "SELECT * FROM products WHERE price > ?");
    assert(query.parameters().length == 1);
    writeln("✓ SELECT with WHERE test passed");
}

void testJoin() {
    writeln("Testing JOIN...");
    auto query = QueryBuilder.create()
        .select("u.name", "o.total")
        .from("users u")
        .leftJoin("orders o", "u.id = o.user_id");
    
    auto sql = query.toSql();
    assert(sql == "SELECT u.name, o.total FROM users u LEFT JOIN orders o ON u.id = o.user_id");
    writeln("✓ JOIN test passed");
}

void testInsert() {
    writeln("Testing INSERT...");
    auto query = QueryBuilder.create()
        .insert("users")
        .values([
            "name": SqlValue("John"),
            "email": SqlValue("john@test.com")
        ]);
    
    auto sql = query.toSql();
    assert(sql.length > 0);
    writeln("✓ INSERT test passed");
}

void testUpdate() {
    writeln("Testing UPDATE...");
    auto query = QueryBuilder.create()
        .update("users")
        .set("name", SqlValue("Jane"))
        .where("id", "=", SqlValue(1));
    
    auto sql = query.toSql();
    assert(sql == "UPDATE users SET name = ? WHERE id = ?");
    writeln("✓ UPDATE test passed");
}

void testDelete() {
    writeln("Testing DELETE...");
    auto query = QueryBuilder.create()
        .delete_()
        .from("users")
        .where("id", "=", SqlValue(1));
    
    auto sql = query.toSql();
    assert(sql == "DELETE FROM users WHERE id = ?");
    writeln("✓ DELETE test passed");
}

void main() {
    writeln("=== Running SQL QueryBuilder Tests ===\n");
    
    testBasicSelect();
    testSelectWithWhere();
    testJoin();
    testInsert();
    testUpdate();
    testDelete();
    
    writeln("\n✓ All tests passed!");
}
