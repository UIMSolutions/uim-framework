/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.helpers.batchinsert;

import uim.databases;

mixin(ShowModule!());

@safe:



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
