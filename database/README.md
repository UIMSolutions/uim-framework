# UIM In-Memory Database

A simple in-memory database library built with D programming language and vibe.d framework.

## Features

- Create and manage tables with custom columns
- Insert rows into tables
- Query rows with optional filtering
- Delete rows with conditions
- Drop tables
- Type-safe variant-based row storage

## Installation

Add to your `dub.json`:

```json
{
  "dependencies": {
    "uim-database": {"path": "../path/to/database"}
  }
}
```

## Usage

```d
import uim.database;
import std.variant;

void main() {
    auto db = new InMemoryDatabase();
    
    // Create a table
    auto usersTable = db.createTable("users", ["id", "name", "email"]);
    
    // Insert data
    usersTable.insert(["id": Variant(1), "name": Variant("Alice"), "email": Variant("alice@example.com")]);
    usersTable.insert(["id": Variant(2), "name": Variant("Bob"), "email": Variant("bob@example.com")]);
    
    // Query all data
    auto users = usersTable.select();
    
    // Query with filter
    auto aliceUsers = usersTable.select((const Row r) => r["name"].get!string() == "Alice");
    
    // Delete with condition
    usersTable.delete_((const Row r) => r["id"].get!int() == 2);
    
    // Drop table
    db.dropTable("users");
}
```

## Project Structure

```
database/
├── dub.json                    # Dub package configuration
├── source/
│   └── uim/
│       └── database/
│           ├── package.d       # Main module exports
│           └── inmemory.d      # In-memory database implementation
├── README.md                   # This file
└── .gitignore                  # Git ignore rules
```

## Building

```bash
dub build
```

## License

MIT
