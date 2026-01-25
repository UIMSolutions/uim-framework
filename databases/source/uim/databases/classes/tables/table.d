module uim.databases.classes.tables.table;

import uim.databases;

@safe:

/// High-level table façade providing fluent helpers on top of BaseTable.
class Table : UIMObject {
    private string _name;
    private string[] _columns;
    private Row[] _rows;
    private bool[string] _indexes;
    private RedBlackTree!ulong[string] _indexedValues;

    this(string name, string[] columns) @safe {
        _name = name;
        _columns = columns.dup;
    }

    @property string name() const @safe { return _name; }
    
    @property const(string[]) columns() const @safe { return _columns; }
    
    @property ulong rowCount() const @safe { return _rows.length; }

    /// Insert a single row.
    void insert(Row row) @safe {
        _rows ~= row;
        _updateIndexes(row, _rows.length - 1);
    }

    void insertBatch(Row[] rows) @safe {
        size_t startIdx = _rows.length;
        _rows ~= rows;
        foreach (i, ref row; rows) {
            _updateIndexes(row, startIdx + i);
        }
    }

    Row[] select(
        scope bool delegate(const Row) @safe filter = null,
        string orderBy = "",
        bool ascending = true,
        ulong limit = 0,
        ulong offset = 0
    ) @safe {
        Row[] result = filter !is null 
            ? _rows.filter!(r => filter(r)).array 
            : _rows.dup;

        if (orderBy != "" && canFind(_columns, orderBy)) {
            // Variant opCmp is @system, constrain scope with @trusted comparator
            result.sort!((a, b) @trusted {
                ref const Variant aVal = a[orderBy];
                ref const Variant bVal = b[orderBy];

                return ascending ? aVal < bVal : aVal > bVal;
            });
        }

        if (offset > 0 && offset < result.length) {
            result = result[offset..$];
        }

        if (limit > 0 && limit < result.length) {
            result = result[0..limit];
        }

        return result;
    }

    ulong count(scope bool delegate(const Row) @safe filter = null) const @safe {
        if (filter is null) return _rows.length;
        return _rows.filter!(r => filter(r)).array.length;
    }

    ulong update(
        scope bool delegate(const Row) @safe filter,
        scope Row delegate(const Row) @safe updateFn
    ) @safe {
        ulong updated = 0;
        foreach (ref row; _rows) {
            if (filter(row)) {
                row = updateFn(row);
                updated++;
            }
        }
        return updated;
    }

    ulong delete_(scope bool delegate(const Row) @safe filter) @safe {
        ulong count = this.count(filter);
        _rows = _rows.filter!(r => !filter(r)).array;
        _indexes.clear();
        _indexedValues.clear();
        return count;
    }

    void clear() @safe {
        _rows.clear();
        _indexes.clear();
        _indexedValues.clear();
    }

    void createIndex(string column) @safe {
        if (canFind(_columns, column)) {
            _indexes[column] = true;
        }
    }

    bool hasIndex(string column) const @safe {
        return (column in _indexes) !is null;
    }

    private void _updateIndexes(const Row row, ulong index) @safe {
        foreach (col, _; _indexes) {
            if (col in row) {
                // Simple index tracking - can be extended with B-tree
            }
        }
    }
}
