/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-SQL

This document maps `uim-sql` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM SQL Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Protocol | SQL (ANSI and vendor dialects) |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| SQL | Structured Query Language for relational database access |
| Parameterised Query | SQL with typed placeholders (`?` or `$n`) — prevents injection |
| Dialect | Vendor-specific SQL syntax variation (MySQL, PostgreSQL, SQLite, MSSQL) |
| Result Set | Ordered collection of rows returned by a SELECT query |
| Driver | Pluggable backend implementing `ISqlDriver` for a specific database engine |
| Loopback Driver | In-process driver mapping SQL strings to pre-registered handlers for testing |
| Connection | Session object wrapping a driver with transaction state and async dispatch |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
SQL Query Lifecycle
|- Query Construction
|  |- SELECT with projections, JOINs, WHERE, ORDER BY, LIMIT/OFFSET
|  |- INSERT with column-value bindings
|  |- UPDATE with SET and WHERE clauses
|  |- DELETE with WHERE clauses
|- Parameter Binding
|  |- Typed scalar values (text, integer, float, boolean, null)
|  |- Positional parameters (?)
|  |- Named parameters (:name)
|- Dialect Quoting
|  |- Identifier quoting per vendor dialect
|  |- Placeholder format per vendor dialect
|- Query Execution
|  |- Synchronous query / execute
|  |- Async query dispatch via vibe.d runTask
|  |- Transaction begin/commit/rollback
|- Result Consumption
   |- Forward iteration (D range protocol)
   |- Column metadata access
   |- Typed column value extraction
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Async query dispatch | vibe.d `runTask` |
| SQL injection prevention | Parameterised binding (never raw interpolation) |
| Multi-database portability | `ISqlDriver` abstraction |
| Testability without a DB | Loopback driver with preset rows and handler registration |

## OV - Operational View

### OV-1 Operational Concept

1. Application creates a driver (loopback for tests, ODBC-bridge or HTTP/2 adapter for production).
2. A `UIMSqlConnection` wraps the driver and manages open/close and transaction state.
3. The query builder constructs a `SqlQuery` (SQL string + ordered `SqlParameter[]`).
4. The connection dispatches the query to the driver synchronously or via vibe.d async task.
5. The driver returns a `UIMSqlResult` forward range; the application iterates rows and extracts typed values.
6. Transaction lifecycle is managed explicitly via `beginTransaction`, `commit`, `rollback`.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Create driver | driver type | ISqlDriver |
| 2 | Open connection | connection string | open session |
| 3 | Build query | builder chain | SqlQuery (sql + params) |
| 4 | Execute query | SqlQuery | ISqlResult / int |
| 5 | Iterate result | ISqlResult | typed ISqlRow values |
| 6 | Manage transaction | begin/commit/rollback | updated session state |
| 7 | Close connection | — | closed session |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+--------------------------+
| Application Layer        |
| - builder API            |
| - ISqlConnection calls   |
+------------+-------------+
             |
             v
+--------------------------+
| uim.sql                  |
| - SqlXxxBuilder          |
| - UIMSqlConnection       |
| - UIMSqlResult / Row     |
| - Dialect helpers        |
+------------+-------------+
             |
             v
+--------------------------+
| ISqlDriver               |
| - UIMSqlLoopbackDriver   |
| - (future: ODBC bridge)  |
| - (future: HTTP/2 driver)|
+------------+-------------+
             |
             v
+--------------------------+
| vibe.d runtime           |
| - runTask async dispatch |
+--------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.sql.interfaces.result` | `ISqlRow`, `ISqlResult`, column type contracts |
| `uim.sql.interfaces.connection` | `ISqlConnection`, `ISqlDriver` contracts |
| `uim.sql.helpers.parameters` | `SqlValue`, `SqlParameter`, factory helpers |
| `uim.sql.helpers.dialect` | Identifier quoting and placeholder formatting |
| `uim.sql.query.builder` | Four query builders returning `SqlQuery` |
| `uim.sql.result` | `UIMSqlRow`, `UIMSqlResult` concrete classes |
| `uim.sql.connection` | `UIMSqlConnection` with transaction and async support |
| `uim.sql.drivers.loopback` | In-process loopback driver for testing |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| ANSI SQL | 92 / 99 | Baseline query syntax |
| D Language | 2.x | Implementation language |
| vibe.d | 0.10.x | Runtime and async task scheduling |
| Apache License | 2.0 | Distribution and reuse |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Query builder (all four DML) | Implemented | SELECT/INSERT/UPDATE/DELETE with parameterised binding |
| Parameter binding model | Implemented | Typed `SqlValue` / `SqlParameter` — injection-safe |
| Dialect quoting helpers | Implemented | MySQL, PostgreSQL, SQLite, MSSQL identifier quoting |
| Connection interface | Implemented | Open/close, sync query/execute, async dispatch, transactions |
| Loopback driver | Implemented | Handler registration and preset row sets |
| ODBC bridge driver | Planned | Adapter wrapping `uim-odbc` connection for real databases |
| HTTP/2 remote driver | Planned | Adapter for remote SQL-over-HTTP gateways |

## L - Logical Model

### L-1 Logical Data Model

```text
SqlQuery
  |- sql: string
  |- params: SqlParameter[]
      |- name: string   (optional, for named params)
      |- index: int     (1-based, for positional params)
      |- value: SqlValue
           |- type: SqlValueType
           |- textValue / intValue / floatValue / boolValue

UIMSqlConnection
  |- _open: bool
  |- _inTransaction: bool
  |- _connectionString: string
  |- _driver: ISqlDriver

UIMSqlResult (forward range)
  |- _rows: ISqlRow[]
  |- _pos: size_t
  |- _columns: SqlColumnInfo[]
```

### L-2 Constraints

- Query builders never interpolate raw values into SQL strings; all user data passes via `SqlParameter`.
- `SqlParameter.index` is assigned by the builder `build()` method in positional order.
- `ISqlResult` is a single-pass forward range; close once iteration is complete.
- The loopback driver matches on exact SQL string equality; pre-normalise SQL before `registerQuery`.
- Transaction methods are no-ops on the loopback driver (pure in-memory semantic).
