module uim.databases.classes.databases.database;

import uim.databases;
import std.exception : enforce;
@safe:

/// High-level database façade that wraps the in-memory engine
/// and exposes type-safe helpers plus query execution.
class Database : UIMObject {
    private DatabaseEngine _engine;
    private Table[string] _tableCache; // Cache for faster table access

    this() @safe {
        _engine = new MemoryEngine();
    }

    /// Create a new table and return a rich Table wrapper.
    Table createTable(string name, string[] columns) @safe {
        enforce(name.length > 0, "Table name cannot be empty");
        enforce(columns.length > 0, "Table must have at least one column");
        
        auto table = _engine.createTable(name, columns);
        _tableCache[name] = table; // Cache the table
        return table;
    }

    /// Get existing table as a wrapper; null if not found.
    Table getTable(string name) @safe {
        // Check cache first
        if (auto cached = name in _tableCache) {
            return *cached;
        }
        
        auto table = _engine.getTable(name);
        if (table !is null) {
            _tableCache[name] = table;
        }
        return table;
    }

    /// Check if a table exists.
    bool hasTable(string name) const @safe {
        return _engine.hasTable(name);
    }

    /// Drop/delete a table by name.
    void dropTable(string name) @safe {
        _engine.dropTable(name);
        _tableCache.remove(name); // Remove from cache
    }

    /// List all table names.
    string[] tableNames() const @safe {
        return _engine.tableNames();
    }

    /// Total row count across all tables.
    ulong rowCount() const @safe {
        return _engine.rowCount();
    }

    /// Clear all tables in the database.
    void clear() @safe {
        _engine.clear();
        _tableCache.clear(); // Clear cache
    }

    /// Execute a QueryBuilder against a specific table.
    Row[] execute(QueryBuilder qb) @safe {
        enforce(qb !is null, "QueryBuilder cannot be null");
        
        auto table = getTable(qb.getTableName());
        if (table is null) {
            return []; // Return empty array for non-existent table
        }
        
        return table.select(
            qb.getFilter(),
            qb.getOrderBy(),
            qb.isAscending(),
            qb.getLimit(),
            qb.getOffset()
        );
    }
}