module uim.databases.classes.databases.database;

import uim.oop.datatypes.objects.obj : UIMObject;
import uim.databases.base.database : InMemoryDatabase;
import uim.databases.base.table : Table as BaseTable;
import uim.databases.interfaces.table : Row;
import uim.databases.helpers : QueryBuilder;
import uim.databases.classes.table : Table;

/// High-level database façade that wraps the in-memory engine
/// and exposes type-safe helpers plus query execution.
class Database : UIMObject {
    private InMemoryDatabase _db;

    this() @safe {
        _db = new InMemoryDatabase();
    }

    /// Create a new table and return a rich Table wrapper.
    Table createTable(string name, string[] columns) @safe {
        auto t = _db.createTable(name, columns);
        return new Table(t);
    }

    /// Get existing table as a wrapper; null if not found.
    Table getTable(string name) @safe {
        auto t = _db.getTable(name);
        return t is null ? null : new Table(t);
    }

    /// Check if a table exists.
    bool hasTable(string name) const @safe {
        return _db.hasTable(name);
    }

    /// Drop/delete a table by name.
    void dropTable(string name) @safe {
        _db.dropTable(name);
    }

    /// List all table names.
    string[] tableNames() const @safe {
        return _db.tableNames();
    }

    /// Total row count across all tables.
    ulong rowCount() const @safe {
        return _db.rowCount();
    }

    /// Clear all tables in the database.
    void clear() @safe {
        _db.clear();
    }

    /// Execute a QueryBuilder against a specific table.
    Row[] execute(QueryBuilder qb) @safe {
        auto table = _db.getTable(qb.getTableName());
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