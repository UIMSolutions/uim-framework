# Library 📚 uim-databases

Updated on 1. February 2026

[![uim-databases](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-databases.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-databases.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A high-performance, type-safe in-memory database library for D with optimized queries, indexing, and batch operations.

## Features

✅ **Type-Safe Interfaces** - `IValuebase` and `ITable` contracts with @safe attributes
✅ **Efficient Filtering** - Advanced WHERE clause support with custom predicates
✅ **Query Optimization** - Sorting, limiting, offset pagination
✅ **Indexing** - Create indexes on columns for faster lookups
✅ **Batch Operations** - Insert multiple rows efficiently with batch builder
✅ **Full CRUD** - Create, read, update, delete operations
✅ **QueryBuilder** - Fluent API for composable queries
✅ **Statistics** - Row counting, table statistics, global metrics
✅ **Variant Storage** - Type-safe heterogeneous row storage
✅ **Memory Efficient** - Minimal overhead, in-memory performance

## Installation

Add to your `dub.json`:

```json
{
  "dependencies": {
    "uim-framework:database": "~>26.2.1"
  }
}
```

## Quick Start

### Basic Operations

```d
import uim.databases;
import std.variant;

void main() {
    // Create database and table
    auto db = new InMemoryDatabase();
    auto usersTable = db.createTable("users", ["id", "name", "email"]);
  
    // Insert single row
    usersTable.insert([
        "id": Variant(1),
        "name": Variant("Alice"),
        "email": Variant("alice@example.com")
    ]);
  
    // Insert batch
    usersTable.insertBatch([
        ["id": Variant(2), "name": Variant("Bob"), "email": Variant("bob@example.com")],
        ["id": Variant(3), "name": Variant("Charlie"), "email": Variant("charlie@example.com")]
    ]);
  
    // Query all rows
    auto allUsers = usersTable.select();
  
    // Query with filter
    auto alice = usersTable.select(
        (const Row r) @safe => r["name"].get!string() == "Alice"
    );
  
    // Query with sorting and limit
    auto limited = usersTable.select(
        null,  // no filter
        "id",  // order by
        true,  // ascending
        2      // limit 2 rows
    );
  
    // Count rows
    ulong total = usersTable.count();
    ulong filtered = usersTable.count(
        (const Row r) @safe => r["id"].get!int() >= 2
    );
  
    // Update rows
    usersTable.update(
        (const Row r) @safe => r["id"].get!int() == 1,
        (const Row r) @safe => Row(["id": Variant(1), "name": Variant("Alice Updated"), "email": r["email"]])
    );
  
    // Delete rows
    usersTable.delete_((const Row r) @safe => r["id"].get!int() == 3);
  
    // Drop table
    db.dropTable("users");
}
```

### Fluent QueryBuilder API

```d
import uim.databases.helpers;

auto query = new QueryBuilder("users")
    .where((const Row r) @safe => r["id"].get!int() > 5)
    .orderBy("name")
    .limit(10)
    .offset(0);
```

### Batch Insert with Builder

```d
import uim.databases.helpers;

auto batch = new BatchInsertBuilder()
    .add(["id": Variant(1), "name": Variant("User1")])
    .add(["id": Variant(2), "name": Variant("User2")])
    .batchSize(1000);

usersTable.insertBatch(batch.getRows());
```

### Indexing

```d
// Create index on frequently queried column
usersTable.createIndex("email");

// Check if column has index
if (usersTable.hasIndex("email")) {
    auto indexed = usersTable.select(
        (const Row r) @safe => r["email"].get!string() == "alice@example.com"
    );
}
```

## Project Structure

```
database/
├── dub.json                       # Package configuration
├── source/
│   └── uim/
│       └── database/
│           ├── package.d          # Main module exports
│           ├── inmemory.d         # Legacy compatibility layer
│           ├── helpers.d          # QueryBuilder, BatchInsertBuilder
│           ├── interfaces/
│           │   ├── package.d
│           │   ├── database.d     # IValuebase interface
│           │   └── table.d        # ITable interface
│           └── base/
│               ├── package.d
│               ├── database.d     # InMemoryDatabase implementation
│               └── table.d        # Table implementation
├── examples/                      # Usage examples
├── tests/                         # Unit tests
├── README.md                      # This file
└── .gitignore
```

## Examples

The `examples/` directory contains practical demonstrations:

- `basic.d` - Basic CRUD operations
- `batch.d` - Batch insert performance
- `queries.d` - Advanced filtering and sorting
- `indexing.d` - Index creation and usage

## Patterns Used

### Factory Pattern

The library uses a factory approach for table creation:

```d
ITable table = db.createTable(name, columns);
```

### Builder Pattern

QueryBuilder and BatchInsertBuilder provide fluent configuration:

```d
auto results = table.select(...).orderBy(...).limit(...);
```

### Strategy Pattern

Delegates allow custom filtering/transformation strategies:

```d
table.select((const Row r) @safe => customFilter(r));
```

## Design Patterns

The uim-database library implements several design patterns for flexibility:

1. **Interface Segregation** - Separate contracts for database and table operations
2. **Type Safety** - @safe/@trusted enforcement throughout
3. **Composition** - Tables composed of rows, queries composed from predicates
4. **Delegation** - Filter and transform operations via delegates
5. **Builder Pattern** - Fluent API construction

## Async Support

While the core library is synchronous, it integrates with vibe.d:

```d
import vibe.d;

auto db = new InMemoryDatabase();
// Perform operations synchronously
// Integrate with async tasks as needed
```

## Notes

- **In-Memory**: All data stored in process memory, no persistence
- **Thread-Safe**: Not thread-safe by default; use external synchronization for multi-threaded access
- **Variant Storage**: Rows use `Variant[string]` for heterogeneous column types
- **Type Conversion**: Use `.get!T()` for type conversion with error handling
- **Large Datasets**: For millions of rows, consider external databases
- **Index Overhead**: Indexes use additional memory; create selectively
- **Batch Size**: Default batch size 1000; tune based on available memory

## License

Apache 2.0
