module uim.databases.classes.databases.database;

import uim.databases;
@safe:

/// High-level database façade that wraps the in-memory engine
/// and exposes type-safe helpers plus query execution.
class Database : UIMObject {
    private DatabaseEngine _engine;

    this() @safe {
        _engine = new MemoryEngine();
    }

    /// Create a new table and return a rich Table wrapper.
    Table createTable(string name, string[] columns) @safe {
        auto t = _engine.createTable(name, columns);
        return new Table(t);
    }

    /// Get existing table as a wrapper; null if not found.
    Table getTable(string name) @safe {
        auto t = _engine.getTable(name);
        return t is null ? null : new Table(t);
    }

    /// Check if a table exists.
    bool hasTable(string name) const @safe {
        return _engine.hasTable(name);
    }

    /// Drop/delete a table by name.
    void dropTable(string name) @safe {
        _engine.dropTable(name);
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
    }

    /// Execute a QueryBuilder against a specific table.
    Row[] execute(QueryBuilder qb) @safe {
        auto table = _engine.getTable(qb.getTableName());
        if (table is null) {
            return [];
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