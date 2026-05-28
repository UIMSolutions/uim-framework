# Library uim-sql

Updated on 28. May 2026

A SQL query builder and connection abstraction library for dlang, built with vibe.d runtime primitives. The library provides parameterised query construction, a dialect-aware identifier quoting system, a generic connection and result interface, and an in-process loopback driver for service-first development and testing.

## Features

- Type-safe SQL query builder for `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- Parameterised binding model (`SqlValue`, `SqlParameter`) — prevents SQL injection
- SQL dialect helpers for identifier quoting and placeholders (`MySQL`, `PostgreSQL`, `SQLite`, `MSSQL`)
- Generic `ISqlConnection` / `ISqlResult` / `ISqlRow` interfaces
- In-memory loopback driver with handler registration and preset row sets
- vibe.d task-based async query dispatch via `queryAsync`
- Complements `uim-odbc` (ODBC C bindings) and `uim-databases` (in-memory table model)

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:sql" version="*"
```

## Quick Start

```d
import uim.sql;

void main() {
  auto driver = SqlLoopbackDriver();
  driver.presetRows("SELECT * FROM users", [
    ["id": "1", "name": "Alice"],
    ["id": "2", "name": "Bob"]
  ]);

  auto conn = SqlConnection(driver);
  conn.open("loopback://");

  // --- parameterised SELECT ---
  auto q = sqlSelect("users")
    .select_("id", "name")
    .where_("active = ?", sqlBool(true))
    .orderBy("name")
    .limit_(20)
    .build();

  auto result = conn.query(q.sql, q.params);
  while (!result.empty()) {
    import std.stdio : writeln;
    writeln(result.front().text("name"));
    result.popFront();
  }

  // --- parameterised INSERT ---
  auto ins = sqlInsert("users")
    .set_("name", sqlText("Charlie"))
    .set_("age",  sqlInt(29))
    .build();
  conn.execute(ins.sql, ins.params);

  conn.close();
}
```

## Modules

- `uim.sql`: package entrypoint and re-exports
- `uim.sql.interfaces.result`: `ISqlRow`, `ISqlResult`, `SqlColumnInfo` contracts
- `uim.sql.interfaces.connection`: `ISqlConnection`, `ISqlDriver` contracts
- `uim.sql.helpers.parameters`: `SqlValue`, `SqlParameter`, factory helpers
- `uim.sql.helpers.dialect`: `SqlDialect`, `quoteIdentifier`, `placeholderFor`
- `uim.sql.query.builder`: `SqlSelectBuilder`, `SqlInsertBuilder`, `SqlUpdateBuilder`, `SqlDeleteBuilder`
- `uim.sql.result`: `UIMSqlRow`, `UIMSqlResult` concrete implementations
- `uim.sql.connection`: `UIMSqlConnection` with transaction support and async dispatch
- `uim.sql.drivers.loopback`: In-process loopback driver for testing

## Notes

All query parameters are bound through `SqlParameter` — raw string interpolation into SQL is never necessary when using the builder API. The loopback driver accepts exact SQL string keys, so integration tests remain fully deterministic without a running database engine. HTTP/2 or ODBC-bridged drivers can be layered on top of `ISqlDriver` without changing application code.
