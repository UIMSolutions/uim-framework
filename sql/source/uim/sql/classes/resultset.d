/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.classes.resultset;

import uim.sql;

@safe:

/**
 * Implementation of result set
 */
class ResultSet : UIMObject, IResultSet {
    mixin(ObjThis!("ResultSet"));

    protected SqlRow[] _rows;
    protected string[] _columnNames;
    protected size_t _currentIndex;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        _currentIndex = 0;
        return true;
    }

    bool next() {
        if (_currentIndex < _rows.length) {
            _currentIndex++;
            return _currentIndex <= _rows.length;
        }
        return false;
    }

    SqlRow currentRow() const @trusted {
        if (_currentIndex > 0 && _currentIndex <= _rows.length) {
            return cast(SqlRow)_rows[_currentIndex - 1];
        }
        return SqlRow();
    }

    SqlValue get(string columnName) const {
        auto row = currentRow();
        return row[columnName];
    }

    SqlValue get(size_t columnIndex) const {
        if (columnIndex >= _columnNames.length) {
            return SqlValue();
        }
        return get(_columnNames[columnIndex]);
    }

    SqlRow[] all() @trusted {
        return _rows.dup;
    }

    SqlRow first() @trusted {
        if (_rows.length > 0) {
            return _rows[0];
        }
        return SqlRow();
    }

    string[] columns() const @trusted {
        return cast(string[])_columnNames;
    }

    size_t rowCount() const {
        return _rows.length;
    }

    bool isEmpty() const {
        return _rows.length == 0;
    }

    void reset() {
        _currentIndex = 0;
    }

    void close() {
        _rows = [];
        _columnNames = [];
        _currentIndex = 0;
    }

    // Range interface
    @property bool empty() const {
        return _currentIndex >= _rows.length;
    }

    @property SqlRow front() const @trusted {
        if (_currentIndex < _rows.length) {
            return cast(SqlRow)_rows[_currentIndex];
        }
        return SqlRow();
    }

    void popFront() {
        if (_currentIndex < _rows.length) {
            _currentIndex++;
        }
    }

    // Helper methods for testing/mocking
    void addRow(SqlRow row) @trusted {
        _rows ~= row;
        
        // Update column names
        foreach (colName; row.columnNames) {
            import std.algorithm : canFind;
            if (!_columnNames.canFind(colName)) {
                _columnNames ~= colName;
            }
        }
    }
}
