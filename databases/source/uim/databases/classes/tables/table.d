module uim.databases.classes.tables.table;

import uim.databases;
import std.algorithm : filter, canFind, sort;
import std.array : array;
import std.container.rbtree : RedBlackTree;

@safe:

/// High-level table façade providing fluent helpers on top of BaseTable.
class Table : UIMObject {
    private string _name;
    private string[] _columns;
    private Row[] _rows;
    private bool[string] _indexes;
    private RedBlackTree!string[string] _indexedValues; // column -> indexed values

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

    /// Insert multiple rows efficiently
    void insertBatch(Row[] rows) @safe {
        if (rows.length == 0) return;
        
        // Reserve capacity to avoid multiple reallocations
        size_t startIdx = _rows.length;
        _rows.reserve(startIdx + rows.length);
        _rows ~= rows;
        
        // Update indexes for all new rows
        foreach (i, ref row; rows) {
            _updateIndexes(row, startIdx + i);
        }
    }

    /// Select rows with advanced filtering, sorting, and pagination
    Row[] select(
        scope bool delegate(const Row) @safe filter = null,
        string orderBy = "",
        bool ascending = true,
        ulong limit = 0,
        ulong offset = 0
    ) @safe {
        Row[] result;
        
        // Optimization: If limit without sort, we can stop early
        if (filter is null && orderBy == "" && limit > 0 && offset == 0) {
            size_t count = limit < _rows.length ? limit : _rows.length;
            result.reserve(count);
            return _rows[0..count].dup;
        }
        
        // Apply filter
        if (filter !is null) {
            // Pre-allocate assuming ~50% match rate for filters
            result.reserve(_rows.length / 2);
            result = _rows.filter!(r => filter(r)).array;
        } else {
            result = _rows.dup;
        }

        // Apply sorting if requested
        if (orderBy != "" && canFind(_columns, orderBy)) {
            // Json comparison may need @trusted for opCmp
            result.sort!((a, b) @trusted {
                auto aPtr = orderBy in a;
                auto bPtr = orderBy in b;
                if (aPtr is null || bPtr is null) return false;
                
                return ascending ? (*aPtr < *bPtr) : (*bPtr < *aPtr);
            });
        }

        // Apply offset
        if (offset > 0 && offset < result.length) {
            result = result[offset..$];
        }

        // Apply limit
        if (limit > 0 && limit < result.length) {
            result = result[0..limit];
        }

        return result;
    }

    /// Count rows matching optional filter
    ulong count(scope bool delegate(const Row) @safe filter = null) const @safe {
        if (filter is null) return _rows.length;
        
        // Optimization: Manual count avoids array allocation
        ulong count = 0;
        foreach (ref row; _rows) {
            if (filter(row)) count++;
        }
        return count;
    }

    /// Update rows matching filter with transformation function
    ulong update(
        scope bool delegate(const Row) @safe filter,
        scope Row delegate(const Row) @safe updateFn
    ) @safe {
        ulong updated = 0;
        size_t[] updatedIndices;
        updatedIndices.reserve(_rows.length / 10); // Assume ~10% update rate
        
        foreach (i, ref row; _rows) {
            if (filter(row)) {
                row = updateFn(row);
                updatedIndices ~= i;
                updated++;
            }
        }
        
        // Rebuild indexes for updated rows
        foreach (idx; updatedIndices) {
            _updateIndexes(_rows[idx], idx);
        }
        
        return updated;
    }

    /// Delete rows matching filter and return count
    ulong delete_(scope bool delegate(const Row) @safe filter) @safe {
        size_t originalLength = _rows.length;
        _rows = _rows.filter!(r => !filter(r)).array;
        ulong deleted = originalLength - _rows.length;
        
        // Rebuild all indexes after deletion
        if (deleted > 0 && _indexes.length > 0) {
            _rebuildAllIndexes();
        }
        
        return deleted;
    }

    void clear() @safe {
        _rows.clear();
        _indexes.clear();
        _indexedValues.clear();
    }

    /// Create an index on a column for faster lookups
    void createIndex(string column) @safe {
        if (canFind(_columns, column)) {
            _indexes[column] = true;
            _buildIndexForColumn(column);
        }
    }

    /// Check if column has an index
    bool hasIndex(string column) const @safe {
        return (column in _indexes) !is null;
    }

    /// Update indexes for a single row
    private void _updateIndexes(const Row row, ulong index) @safe {
        foreach (col, _; _indexes) {
            if (auto valPtr = col in row) {
                // Track indexed values for potential B-tree implementation
                if (col !in _indexedValues) {
                    _indexedValues[col] = new RedBlackTree!string();
                }
                try {
                    auto strVal = (*valPtr).toString();
                    _indexedValues[col].insert(strVal);
                } catch (Exception e) {
                    // Skip if value can't be converted to string
                }
            }
        }
    }
    
    /// Build index for specific column
    private void _buildIndexForColumn(string column) @safe {
        if (column !in _indexedValues) {
            _indexedValues[column] = new RedBlackTree!string();
        }
        
        foreach (ref row; _rows) {
            if (auto valPtr = column in row) {
                try {
                    auto strVal = (*valPtr).toString();
                    _indexedValues[column].insert(strVal);
                } catch (Exception e) {
                    // Skip invalid values
                }
            }
        }
    }
    
    /// Rebuild all indexes from scratch
    private void _rebuildAllIndexes() @safe {
        _indexedValues.clear();
        foreach (col, _; _indexes) {
            _buildIndexForColumn(col);
        }
    }
}
