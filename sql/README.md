# UIM SQL Library

A comprehensive SQL library for the UIM Framework providing database abstraction and SQL operations.

## Features

- **Connection Management**: Connect to various SQL databases
- **Query Building**: Fluent API for building SQL queries
- **Result Sets**: Efficient result set handling
- **Transactions**: Transaction support with commit/rollback
- **Prepared Statements**: Safe parameterized queries
- **Schema Operations**: DDL operations for table/index management
- **Multiple Dialects**: Support for different SQL dialects (MySQL, PostgreSQL, SQLite, etc.)

## Basic Usage

```d
import uim.sql;

// Create a connection
auto conn = Connection.create("mysql://localhost/mydb");
conn.connect();

// Execute a query
auto result = conn.query("SELECT * FROM users WHERE active = ?", true);
foreach (row; result) {
    writeln(row["name"].asString);
}

// Query builder
auto query = QueryBuilder.create()
    .select("id", "name", "email")
    .from("users")
    .where("age", ">", 18)
    .orderBy("name")
    .limit(10);

auto result = conn.execute(query);

// Transactions
auto tx = conn.beginTransaction();
try {
    conn.execute("INSERT INTO users (name) VALUES (?)", "John");
    conn.execute("UPDATE accounts SET balance = balance - 100 WHERE id = 1");
    tx.commit();
} catch (Exception e) {
    tx.rollback();
}

conn.close();
```

## Components

### Interfaces
- `IConnection`: Database connection management
- `IStatement`: SQL statement execution
- `IResultSet`: Query result handling
- `ITransaction`: Transaction management
- `IQueryBuilder`: Fluent query construction
- `IDialect`: SQL dialect abstraction

### Classes
- `Connection`: Base connection implementation
- `Statement`: Prepared statement implementation
- `ResultSet`: Result set with row iteration
- `Transaction`: Transaction handling
- `QueryBuilder`: SQL query builder
- `Dialect`: SQL dialect implementations

## License

Apache-2.0
