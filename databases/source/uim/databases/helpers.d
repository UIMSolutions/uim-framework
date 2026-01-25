/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.helpers;

import uim.databases;
import std.exception : enforce;
@safe:

/// Fluent query builder for constructing database queries
class QueryBuilder {
    private string _tableName;
    private bool delegate(const Row) @safe _filter;
    private string _orderBy = "";
    private bool _ascending = true;
    private ulong _limitValue = 0;
    private ulong _offsetValue = 0;

    this(string tableName) @safe {
        enforce(tableName.length > 0, "Table name cannot be empty");
        _tableName = tableName;
    }

    /// Add WHERE clause filter
    QueryBuilder where(bool delegate(const Row) @safe filter) @safe {
        _filter = filter;
        return this;
    }

    /// Set ORDER BY column and direction
    QueryBuilder orderBy(string column, bool ascending = true) @safe {
        _orderBy = column;
        _ascending = ascending;
        return this;
    }

    /// Set LIMIT for result count
    QueryBuilder limit(ulong count) @safe {
        _limitValue = count;
        return this;
    }

    /// Set OFFSET for pagination
    QueryBuilder offset(ulong count) @safe {
        _offsetValue = count;
        return this;
    }
    
    /// Reset query parameters for reuse
    QueryBuilder reset() @safe {
        _filter = null;
        _orderBy = "";
        _ascending = true;
        _limitValue = 0;
        _offsetValue = 0;
        return this;
    }

    string getTableName() const @safe {
        return _tableName;
    }

    bool delegate(const Row) @safe getFilter() const @safe {
        return _filter;
    }

    string getOrderBy() const @safe {
        return _orderBy;
    }

    bool isAscending() const @safe {
        return _ascending;
    }

    ulong getLimit() const @safe {
        return _limitValue;
    }

    ulong getOffset() const @safe {
        return _offsetValue;
    }
}

/// Batch insert builder for efficient multi-row insertions
class BatchInsertBuilder {
    private TableRow[] _rows;
    private ulong _batchSize = 1000;

    this() @safe {
        _rows.reserve(_batchSize); // Pre-allocate for efficiency
    }

    /// Add a single row to the batch
    BatchInsertBuilder add(TableRow row) @safe {
        _rows ~= row;
        return this;
    }

    /// Add multiple rows at once
    BatchInsertBuilder addMultiple(TableRow[] rows) @safe {
        if (rows.length > 0) {
            _rows.reserve(_rows.length + rows.length);
            _rows ~= rows;
        }
        return this;
    }

    /// Set preferred batch size for operations
    BatchInsertBuilder batchSize(ulong size) @safe {
        _batchSize = size;
        return this;
    }

    /// Get all accumulated rows
    TableRow[] getRows() @safe {
        return _rows.dup;
    }
    
    /// Get number of rows currently in batch
    ulong rowCount() const @safe {
        return _rows.length;
    }

    /// Get configured batch size
    ulong getBatchSize() const @safe {
        return _batchSize;
    }

    /// Clear all rows from batch
    void clear() @trusted {
        _rows.length = 0;
        _rows.assumeSafeAppend(); // Allow reuse of memory
    }
    
    /// Check if batch is empty
    bool isEmpty() const @safe {
        return _rows.length == 0;
    }
    
    /// Check if batch has reached configured batch size
    bool isFull() const @safe {
        return _rows.length >= _batchSize;
    }
}
