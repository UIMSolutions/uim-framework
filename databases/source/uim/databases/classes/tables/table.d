module uim.databases.classes.table;

import uim.oop.datatypes.objects.obj : UIMObject;
import uim.databases.base.table : Table as BaseTable;
import uim.databases.helpers : QueryBuilder, BatchInsertBuilder;
import uim.databases.interfaces.table : Row;

/// High-level table façade providing fluent helpers on top of BaseTable.
class Table : UIMObject {
    private BaseTable _table;

    this(BaseTable table) @safe {
        _table = table;
    }

    @property string name() const @safe { return _table.name(); }
    @property const(string[]) columns() const @safe { return _table.columns(); }
    @property ulong rowCount() const @safe { return _table.rowCount(); }

    /// Insert a single row.
    void insert(Row row) @safe { _table.insert(row); }

    /// Insert rows in bulk using a builder or array.
    void insertBatch(Row[] rows) @safe { _table.insertBatch(rows); }
    void insertBatch(BatchInsertBuilder builder) @safe { _table.insertBatch(builder.getRows()); }

    /// Select with optional filter, sorting, pagination.
    Row[] select(
        scope bool delegate(const Row) @safe filter = null,
        string orderBy = "",
        bool ascending = true,
        ulong limit = 0,
        ulong offset = 0
    ) @safe {
        return _table.select(filter, orderBy, ascending, limit, offset);
    }

    /// Select using a QueryBuilder.
    Row[] select(QueryBuilder qb) @safe {
        return _table.select(
            qb.getFilter(),
            qb.getOrderBy(),
            qb.isAscending(),
            qb.getLimit(),
            qb.getOffset()
        );
    }

    /// Count rows optionally filtered.
    ulong count(scope bool delegate(const Row) @safe filter = null) const @safe {
        return _table.count(filter);
    }

    /// Update rows matching filter with updateFn.
    ulong update(
        scope bool delegate(const Row) @safe filter,
        scope Row delegate(const Row) @safe updateFn
    ) @safe {
        return _table.update(filter, updateFn);
    }

    /// Delete rows matching filter.
    ulong delete_(scope bool delegate(const Row) @safe filter) @safe {
        return _table.delete_(filter);
    }

    /// Remove all rows.
    void clear() @safe { _table.clear(); }

    /// Index helpers.
    void createIndex(string column) @safe { _table.createIndex(column); }
    bool hasIndex(string column) const @safe { return _table.hasIndex(column); }
}