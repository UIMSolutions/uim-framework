/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.base.table;

import uim.databases.interfaces.table;
import std.algorithm : filter, sort, canFind;
import std.array : array;
import std.variant : Variant;
import std.container.rbtree : RedBlackTree;

class Table : ITable {
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
            result.sort!((a, b) @safe {
                auto aVal = a[orderBy];
                auto bVal = b[orderBy];
                
                if (ascending) {
                    if (aVal < bVal) return true;
                    return false;
                } else {
                    if (aVal > bVal) return true;
                    return false;
                }
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
