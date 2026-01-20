/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.classes.statement;

import uim.sql;

@safe:

/**
 * Implementation of prepared statement
 */
class Statement : UIMObject, IStatement {
    mixin(ObjThis!("Statement"));

    protected string _sql;
    protected IConnection _connection;
    protected SqlValue[] _params;
    protected SqlValue[string] _namedParams;

    this(string sql, IConnection connection) {
        super();
        _sql = sql;
        _connection = connection;
    }

    void bind(size_t index, SqlValue value) @trusted {
        if (index == 0) {
            throw new Exception("Parameter index must be 1-based");
        }
        
        if (_params.length < index) {
            _params.length = index;
        }
        _params[index - 1] = value;
    }

    void bind(string name, SqlValue value) @trusted {
        _namedParams[name] = value;
    }

    void bindAll(SqlValue[] values) @trusted {
        _params = values.dup;
    }

    IResultSet execute() @trusted {
        auto processedSql = replacePlaceholders();
        return _connection.query(processedSql, _params);
    }

    QueryResult executeCommand() @trusted {
        auto processedSql = replacePlaceholders();
        return _connection.execute(processedSql, _params);
    }

    void reset() {
        _params = [];
        _namedParams.clear();
    }

    string sql() const {
        return _sql;
    }

    void close() {
        reset();
    }

    protected string replacePlaceholders() @trusted {
        import std.string : indexOf, replace;
        
        string result = _sql;
        
        // Replace named parameters
        foreach (name, value; _namedParams) {
            result = result.replace(":" ~ name, "?");
            _params ~= value;
        }
        
        return result;
    }
}
