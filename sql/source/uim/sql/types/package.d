/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.types;

import uim.sql.enums;
import std.variant : Variant;
import std.datetime : DateTime, Date, TimeOfDay;

/**
 * SQL value wrapper supporting multiple types
 */
struct SqlValue {
    Variant value;
    SqlType type;

    this(T)(T val) @trusted {
        value = Variant(val);
        type = inferType!T();
    }

    this(this) @trusted {
    }

    ref SqlValue opAssign(SqlValue rhs) @trusted return {
        value = rhs.value;
        type = rhs.type;
        return this;
    }

    bool isNull() const @trusted {
        return type == SqlType.NULL || !value.hasValue;
    }

    T as(T)() const @trusted {
        return value.get!T;
    }

    string asString() const @trusted {
        if (isNull) return null;
        return value.get!string;
    }

    long asLong() const @trusted {
        if (isNull) return 0;
        return value.get!long;
    }

    double asDouble() const @trusted {
        if (isNull) return 0.0;
        return value.get!double;
    }

    bool asBool() const @trusted {
        if (isNull) return false;
        return value.get!bool;
    }

    private static SqlType inferType(T)() {
        static if (is(T == string)) {
            return SqlType.VARCHAR;
        } else static if (is(T : long)) {
            return SqlType.BIGINT;
        } else static if (is(T : int)) {
            return SqlType.INTEGER;
        } else static if (is(T : double) || is(T : float)) {
            return SqlType.DOUBLE;
        } else static if (is(T == bool)) {
            return SqlType.BOOLEAN;
        } else static if (is(T == DateTime)) {
            return SqlType.DATETIME;
        } else static if (is(T == Date)) {
            return SqlType.DATE;
        } else static if (is(T == TimeOfDay)) {
            return SqlType.TIME;
        } else {
            return SqlType.VARCHAR;
        }
    }
}

/**
 * SQL row representation
 */
struct SqlRow {
    @trusted:
    SqlValue[string] columns;

    SqlValue opIndex(string columnName) const {
        return columns.get(columnName, SqlValue.init);
    }

    void opIndexAssign(SqlValue value, string columnName) {
        columns[columnName] = value;
    }

    bool has(string columnName) const {
        return (columnName in columns) !is null;
    }

    string[] columnNames() const {
        return columns.keys;
    }
}

/**
 * Connection configuration
 */
struct ConnectionConfig {
    string host = "localhost";
    ushort port = 3306;
    string database;
    string username;
    string password;
    SqlDialect dialect = SqlDialect.GENERIC;
    uint connectionTimeout = 30;
    uint maxConnections = 10;
    bool autoReconnect = true;
    string charset = "utf8mb4";
}

/**
 * Query execution result
 */
struct QueryResult {
    bool success;
    ulong affectedRows;
    ulong lastInsertId;
    string errorMessage;
}
