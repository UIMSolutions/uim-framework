/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.helpers;

import uim.databases.interfaces.table;
import std.variant : Variant;

class QueryBuilder {
    private string _tableName;
    private bool delegate(const Row) @safe _filter;
    private string _orderBy = "";
    private bool _ascending = true;
    private ulong _limitValue = 0;
    private ulong _offsetValue = 0;

    this(string tableName) @safe {
        _tableName = tableName;
    }

    QueryBuilder where(bool delegate(const Row) @safe filter) @safe {
        _filter = filter;
        return this;
    }

    QueryBuilder orderBy(string column, bool ascending = true) @safe {
        _orderBy = column;
        _ascending = ascending;
        return this;
    }

    QueryBuilder limit(ulong count) @safe {
        _limitValue = count;
        return this;
    }

    QueryBuilder offset(ulong count) @safe {
        _offsetValue = count;
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

class BatchInsertBuilder {
    private Row[] _rows;
    private ulong _batchSize = 1000;

    this() @safe {}

    BatchInsertBuilder add(Row row) @safe {
        _rows ~= row;
        return this;
    }

    BatchInsertBuilder addMultiple(Row[] rows) @safe {
        _rows ~= rows;
        return this;
    }

    BatchInsertBuilder batchSize(ulong size) @safe {
        _batchSize = size;
        return this;
    }

    Row[] getRows() const @safe {
        return _rows.dup;
    }

    ulong getBatchSize() const @safe {
        return _batchSize;
    }

    void clear() @safe {
        _rows.clear();
    }
}
