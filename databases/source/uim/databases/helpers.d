/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.helpers;

import uim.databases;

mixin(ShowModule!());

@safe:

/// Fluent query builder for constructing database queries
class QueryBuilder {
    protected string _tableName;
    protected bool delegate(const TableRow) @safe _filter;
    protected string _orderBy = "";
    protected bool _ascending = true;
    protected ulong _limitValue = 0;
    protected ulong _offsetValue = 0;

    this(string tableName) {
        enforce(tableName.length > 0, "Table name cannot be empty");
        _tableName = tableName;
    }

    /// Add WHERE clause filter
    QueryBuilder where(bool delegate(const TableRow) @safe filter) {
        _filter = filter;
        return this;
    }

    /// Set ORDER BY column and direction
    QueryBuilder orderBy(string column, bool ascending = true) {
        _orderBy = column;
        _ascending = ascending;
        return this;
    }

    /// Set LIMIT for result count
    QueryBuilder limit(ulong count) {
        _limitValue = count;
        return this;
    }

    /// Set OFFSET for pagination
    QueryBuilder offset(ulong count) {
        _offsetValue = count;
        return this;
    }

    /// Reset query parameters for reuse
    QueryBuilder reset() {
        _filter = null;
        _orderBy = "";
        _ascending = true;
        _limitValue = 0;
        _offsetValue = 0;
        return this;
    }

    string getTableName() const {
        return _tableName;
    }

    bool delegate(const TableRow) getFilter() const {
        return _filter;
    }

    string getOrderBy() const {
        return _orderBy;
    }

    bool isAscending() const {
        return _ascending;
    }

    ulong getLimit() const {
        return _limitValue;
    }

    ulong getOffset() const {
        return _offsetValue;
    }
}

/// Batch insert builder for efficient multi-row insertions
class BatchInsertBuilder {
    private TableRow[] _rows;
    private ulong _batchSize = 1000;

    this() {
        _rows.reserve(_batchSize); // Pre-allocate for efficiency
    }

    /// Add a single row to the batch
    BatchInsertBuilder add(TableRow row) {
        _rows ~= row;
        return this;
    }

    /// Add multiple rows at once
    BatchInsertBuilder addMultiple(TableRow[] rows) {
        if (rows.length > 0) {
            _rows.reserve(_rows.length + rows.length);
            _rows ~= rows;
        }
        return this;
    }

    /// Set preferred batch size for operations
    BatchInsertBuilder batchSize(ulong size) {
        _batchSize = size;
        return this;
    }

    /// Get all accumulated rows
    TableRow[] getRows() {
        return _rows.dup;
    }

    /// Get number of rows currently in batch
    ulong rowCount() const {
        return _rows.length;
    }

    /// Get configured batch size
    ulong getBatchSize() const {
        return _batchSize;
    }

    /// Clear all rows from batch
    void clear() @trusted {
        _rows.length = 0;
        _rows.assumeSafeAppend(); // Allow reuse of memory
    }

    /// Check if batch is empty
    bool isEmpty() const {
        return _rows.length == 0;
    }

    /// Check if batch has reached configured batch size
    bool isFull() const {
        return _rows.length >= _batchSize;
    }
}
