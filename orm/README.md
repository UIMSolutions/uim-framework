# UIM ORM - Object-Relational Mapping Library

A comprehensive, type-safe ORM (Object-Relational Mapping) library for D language with async/await support via vibe.d. Provides query builders, model mapping, relationships, migrations, and connection pooling.

## Overview

UIM ORM is an asynchronous ORM library built on top of the UIM framework, providing a elegant and efficient way to interact with databases in D language applications. It integrates seamlessly with vibe.d for non-blocking database operations.

## Key Features

### Core Capabilities
- **Query Builder**: Fluent SQL query builder with support for SELECT, INSERT, UPDATE, DELETE
- **Model Mapping**: Object-relational mapping with entity-to-database row conversion
- **Database Connections**: Connection pooling and management for multiple databases
- **Async Operations**: Full async/await support using vibe.d task system
- **Type Safety**: Compile-time type checking with D's strong type system

### Advanced Features
- **Relationships**: Support for HasOne, HasMany, BelongsTo, and BelongsToMany relationships
- **Eager Loading**: Optimize queries with relationship pre-loading
- **Migrations**: Version-controlled database schema management
- **Transactions**: Support for database transactions with commit/rollback
- **Parameterized Queries**: Protection against SQL injection with parameter binding

### Database Support
- MySQL (via mysql-native)
- SQLite (via d2sqlite3)
- Extensible interface for other databases (PostgreSQL, MSSQL, etc.)

## Installation

Add the dependency to your `dub.sdl`:

```d
dependency "uim-orm" version="*"
```

## Quick Start

### Basic Query Builder Usage

```d
import uim.orm;

void main() {
    // Create a database connection
    auto db = new MySQLDatabase("localhost", 3306, "myapp", "user", "password");
    db.connect();

    // Build and execute a query
    auto query = new SQLQueryBuilder(db)
        .select("id", "name", "email")
        .from("users")
        .where("active = ?", ["active": Json(true)])
        .orderBy("created_at", "DESC")
        .limit(10);

    query.get((bool success, Json[] results) {
        if (success) {
            foreach (row; results) {
                writeln("User: ", row["name"].get!string);
            }
        }
    });
}
```

## Core Components

### IDatabase Interface

```d
interface IDatabase {
    string driver();
    bool isConnected() @safe;
    void connect() @trusted;
    void disconnect() @trusted;
    void query(string sql, void delegate(bool success, Json result) @safe callback) @trusted;
    void beginTransaction() @trusted;
    void commit() @trusted;
    void rollback() @trusted;
}
```

### IQuery Interface

```d
interface IQuery {
    IQuery select(string[] columns...);
    IQuery from(string table);
    IQuery where(string condition);
    IQuery orderBy(string column, string direction = "ASC");
    IQuery limit(size_t count);
    IQuery join(string table, string condition, string type = "INNER");
    
    void execute(void delegate(bool success, Json result) @safe callback) @trusted;
    void get(void delegate(bool success, Json[] results) @safe callback) @trusted;
    void count(void delegate(bool success, long count) @safe callback) @trusted;
}
```

### IORMModel Interface

```d
interface IORMModel {
    string tableName();
    string primaryKey();
    string[string] columnMappings();
    bool hasTimestamps();
    
    void find(long id, void delegate(bool success, IEntity entity) @safe callback) @trusted;
    void all(void delegate(bool success, IEntity[] entities) @safe callback) @trusted;
    void create(IEntity entity, void delegate(bool success, IEntity result) @safe callback) @trusted;
    void update(IEntity entity, void delegate(bool success, IEntity result) @safe callback) @trusted;
    void delete(IEntity entity, void delegate(bool success) @safe callback) @trusted;
}
```

## Usage Examples

### Define an ORM Model

```d
class User : ORMModel {
    override string tableName() { return "users"; }
    override string primaryKey() { return "id"; }
    override bool hasTimestamps() { return true; }
    
    override string[string] columnMappings() {
        return [
            "id": "id",
            "username": "username",
            "email": "email",
            "created_at": "createdAt",
            "updated_at": "updatedAt"
        ];
    }
}
```

### Query Data

```d
auto user = new User();
user.setDatabase(db);

// Find all users
user.all((bool success, IEntity[] entities) {
    if (success) {
        foreach (entity; entities) {
            writeln("Found user: ", entity.name());
        }
    }
});

// Find by ID
user.find(123, (bool success, IEntity entity) {
    if (success) {
        writeln("User email: ", entity.getAttribute("email"));
    }
});
```

### Working with Relationships

```d
class Post : ORMModel {
    override string tableName() { return "posts"; }
    
    // Define relationships
    Relationship authorRelation() {
        return new Relationship(RelationType.BelongsTo, "User", "user_id");
    }
    
    Relationship commentsRelation() {
        return new Relationship(RelationType.HasMany, "Comment", "post_id");
    }
}
```

### Database Transactions

```d
db.beginTransaction();
try {
    // Execute operations
    user.create(newUser, (bool success, IEntity result) {
        if (success) {
            db.commit();
        } else {
            db.rollback();
        }
    });
} catch (Exception ex) {
    db.rollback();
    writeln("Error: ", ex.msg);
}
```

### Database Migrations

```d
class CreateUsersTable : Migration {
    this() { super("2026_01_24_create_users_table"); }
    
    override void up(IDatabase database, void delegate(bool success) @safe callback) @trusted {
        string sql = "CREATE TABLE users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL UNIQUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )";
        database.query(sql, (bool success, Json result) {
            callback(success);
        });
    }
    
    override void down(IDatabase database, void delegate(bool success) @safe callback) @trusted {
        database.query("DROP TABLE users", (bool success, Json result) {
            callback(success);
        });
    }
}
```

## Module Structure

```
uim.orm
├── uim.orm.interfaces    # Interface contracts
│   ├── database.d        # IDatabase interface
│   ├── query.d           # IQuery interface
│   └── model.d           # IORMModel interface
├── uim.orm.builders      # Query building
│   └── query.d           # SQLQueryBuilder
├── uim.orm.connections   # Database connections
│   └── base.d            # BaseDatabase, ConnectionPool
├── uim.orm.mappers       # Entity mapping
│   └── model.d           # ORMModel, EntityMapper
├── uim.orm.relationships # Relationship handling
│   └── relation.d        # Relationship, RelationshipLoader
├── uim.orm.migrations    # Schema management
│   └── migration.d       # Migration, MigrationRunner
└── uim.orm.helpers       # Utility functions
```

## Design Patterns

### 1. **Query Builder Pattern**
   - Fluent interface for building complex SQL queries
   - Method chaining for readable code

### 2. **Active Record Pattern**
   - Models combine data and behavior
   - Direct database operations on entities

### 3. **Data Mapper Pattern**
   - EntityMapper separates model from persistence
   - Converts between database rows and entities

### 4. **Object-Relational Mapping**
   - Automatic conversion between objects and tables
   - Column mapping for flexibility

### 5. **Connection Pool Pattern**
   - DatabaseConnectionPool manages multiple connections
   - Efficient resource utilization

### 6. **Repository Pattern (Optional)**
   - Can be layered on top of models
   - Provides data access abstraction

## Async Operations

All database operations are asynchronous and use callbacks:

```d
// Async query execution
query.get((bool success, Json[] results) {
    if (success) {
        // Process results
    } else {
        // Handle error
    }
});

// Async model operations
user.find(id, (bool success, IEntity entity) {
    if (success) {
        // Use entity
    }
});
```

## Transaction Management

```d
db.beginTransaction();

// Perform operations...

db.commit();    // Save changes
// or
db.rollback();  // Undo changes
```

## Performance Considerations

1. **Eager Loading**: Use relationship loaders to prevent N+1 queries
2. **Connection Pooling**: Reuse database connections efficiently
3. **Parameterized Queries**: Reduce query parsing overhead
4. **Async Operations**: Non-blocking database access prevents thread blocking
5. **Select Optimization**: Only select needed columns

## Error Handling

The ORM provides error information through callbacks:

```d
query.execute((bool success, Json result) {
    if (!success) {
        // Handle database error
        // Check last error from database
    }
});
```

## Thread Safety

Current implementation is async-safe with vibe.d task system. For multi-threaded environments:
- Use separate connections per thread
- Synchronize shared state
- Leverage vibe.d's task-based concurrency

## Extending the ORM

### Add Database Driver Support

```d
class PostgreSQLDatabase : BaseDatabase {
    override void connect() @trusted {
        // PostgreSQL-specific connection
    }
    
    override void query(string sql, ...) @trusted {
        // PostgreSQL-specific query execution
    }
}
```

### Custom Validators

Integrate with uim-entities validators for model validation before persistence.

## Dependencies

- **uim-core**: Core framework utilities
- **uim-oop**: Object-oriented patterns
- **uim-entities**: Entity management
- **uim-events**: Event system
- **vibe-d**: Async I/O framework
- **mysql-native**: MySQL driver
- **d2sqlite3**: SQLite driver
