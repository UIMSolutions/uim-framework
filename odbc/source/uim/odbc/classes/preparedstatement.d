/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.preparedstatement;

import uim.odbc.bindings.sql;
import uim.odbc.classes.exception;
import uim.odbc.classes.resultset;
import uim.odbc.classes.resultsetmetadata;
import uim.odbc.types;

import std.datetime  : Date, TimeOfDay, DateTime;
import std.typecons  : Nullable, nullable;
import std.string    : toStringz;
import std.conv      : to;

// ---------------------------------------------------------------------------
// OdbcPreparedStatement – pre-compiled parameterised SQL.
// ---------------------------------------------------------------------------

/**
 * Internal representation of one bound parameter.
 *
 * Because SQLBindParameter requires the data buffer to remain alive until
 * the statement is executed, each OdbcParam holds the D-managed buffer.
 */
private struct OdbcParam {
    SQLSMALLINT sqlType;        /// SQL_* type for ODBC
    SQLSMALLINT cType;          /// SQL_C_* type for ODBC
    SQLULEN     columnSize;     /// Column size / string length
    SQLSMALLINT decimalDigits;  /// Decimal digits (0 for most types)
    ubyte[]     data;           /// Raw value bytes (may be null for SQL NULL)
    SQLLEN      indicator;      /// SQL_NULL_DATA or data byte-length / SQL_NTS
}

/**
 * Executes a pre-compiled SQL statement with typed parameter binding.
 *
 * Obtain an instance from OdbcConnection.prepareStatement().
 * Parameters are 1-based to match ODBC conventions.
 *
 * Batch operations:
 * Call setXxx() + addBatch() once per row, then call executeBatch() to
 * execute all rows in sequence.
 *
 * Example:
 * ---
 * auto ps = conn.prepareStatement("INSERT INTO t(id, val) VALUES (?, ?)");
 * ps.setInt(1, nullable(101));
 * ps.setCString(2, "hello");
 * ps.addBatch();
 *
 * ps.setInt(1, nullable(102));
 * ps.setCString(2, "world");
 * ps.addBatch();
 *
 * ps.executeBatch();
 * conn.commit();
 * ---
 */
class OdbcPreparedStatement {

    // ── Parameter setters – boolean ───────────────────────────────────────────

    /// Binds a nullable bool to the parameter at `idx` (1-based).
    void setBoolean(ushort idx, Nullable!bool value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_BIT, SQL_C_BIT, 1, 0);
        } else {
            SQLCHAR v = value.get ? 1 : 0;
            _setFixed(idx, SQL_BIT, SQL_C_BIT, 1, 0, &v, SQLCHAR.sizeof);
        }
    }

    // ── Integers ──────────────────────────────────────────────────────────────

    /// Binds a nullable byte.
    void setByte(ushort idx, Nullable!byte value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_TINYINT, SQL_C_STINYINT, 3, 0); return; }
        SQLSCHAR v = cast(SQLSCHAR)value.get;
        _setFixed(idx, SQL_TINYINT, SQL_C_STINYINT, 3, 0, &v, SQLSCHAR.sizeof);
    }

    /// Binds a nullable ubyte.
    void setUByte(ushort idx, Nullable!ubyte value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_TINYINT, SQL_C_UTINYINT, 3, 0); return; }
        SQLCHAR v = value.get;
        _setFixed(idx, SQL_TINYINT, SQL_C_UTINYINT, 3, 0, &v, SQLCHAR.sizeof);
    }

    /// Binds a nullable short.
    void setShort(ushort idx, Nullable!short value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_SMALLINT, SQL_C_SSHORT, 5, 0); return; }
        SQLSMALLINT v = value.get;
        _setFixed(idx, SQL_SMALLINT, SQL_C_SSHORT, 5, 0, &v, SQLSMALLINT.sizeof);
    }

    /// Binds a nullable ushort.
    void setUShort(ushort idx, Nullable!ushort value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_SMALLINT, SQL_C_USHORT, 5, 0); return; }
        SQLUSMALLINT v = value.get;
        _setFixed(idx, SQL_SMALLINT, SQL_C_USHORT, 5, 0, &v, SQLUSMALLINT.sizeof);
    }

    /// Binds a nullable int.
    void setInt(ushort idx, Nullable!int value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_INTEGER, SQL_C_SLONG, 10, 0); return; }
        SQLINTEGER v = value.get;
        _setFixed(idx, SQL_INTEGER, SQL_C_SLONG, 10, 0, &v, SQLINTEGER.sizeof);
    }

    /// Binds a nullable uint.
    void setUInt(ushort idx, Nullable!uint value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_INTEGER, SQL_C_ULONG, 10, 0); return; }
        SQLUINTEGER v = value.get;
        _setFixed(idx, SQL_INTEGER, SQL_C_ULONG, 10, 0, &v, SQLUINTEGER.sizeof);
    }

    /// Binds a nullable long.
    void setLong(ushort idx, Nullable!long value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_BIGINT, SQL_C_SBIGINT, 19, 0); return; }
        SQLBIGINT v = value.get;
        _setFixed(idx, SQL_BIGINT, SQL_C_SBIGINT, 19, 0, &v, SQLBIGINT.sizeof);
    }

    /// Binds a nullable ulong.
    void setULong(ushort idx, Nullable!ulong value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_BIGINT, SQL_C_UBIGINT, 20, 0); return; }
        SQLUBIGINT v = value.get;
        _setFixed(idx, SQL_BIGINT, SQL_C_UBIGINT, 20, 0, &v, SQLUBIGINT.sizeof);
    }

    // ── Floating point ────────────────────────────────────────────────────────

    /// Binds a nullable float.
    void setFloat(ushort idx, Nullable!float value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_REAL, SQL_C_FLOAT, 7, 0); return; }
        SQLREAL v = value.get;
        _setFixed(idx, SQL_REAL, SQL_C_FLOAT, 7, 0, &v, SQLREAL.sizeof);
    }

    /// Binds a nullable double.
    void setDouble(ushort idx, Nullable!double value) @trusted {
        if (value.isNull) { _setNull(idx, SQL_DOUBLE, SQL_C_DOUBLE, 15, 0); return; }
        SQLDOUBLE v = value.get;
        _setFixed(idx, SQL_DOUBLE, SQL_C_DOUBLE, 15, 0, &v, SQLDOUBLE.sizeof);
    }

    // ── Decimal ───────────────────────────────────────────────────────────────

    /// Binds a nullable OdbcDecimal.
    void setDecimal(ushort idx, Nullable!OdbcDecimal value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_NUMERIC, SQL_C_NUMERIC, 38, 0);
            return;
        }
        OdbcDecimal d = value.get;
        SQL_NUMERIC_STRUCT ns;
        ns.precision = d.precision;
        ns.scale     = cast(SQLSCHAR)d.scale;
        ns.sign      = d.signum() >= 0 ? 1 : 0;
        // Convert unscaled string to little-endian 128-bit integer in val[]
        // For simplicity, convert via ulong (works for precision ≤ 18)
        ulong mag = 0;
        foreach (ch; d.unscaledValue())
            mag = mag * 10 + (ch - '0');
        foreach (i; 0 .. 8) {
            ns.val[i]     = cast(SQLCHAR)((mag >> (i * 8)) & 0xFF);
            ns.val[8 + i] = 0;
        }
        _setFixed(idx, SQL_NUMERIC, SQL_C_NUMERIC,
                  d.precision, cast(SQLSMALLINT)d.scale,
                  &ns, SQL_NUMERIC_STRUCT.sizeof);
    }

    // ── Strings ───────────────────────────────────────────────────────────────

    /// Binds a nullable D string (converted to UTF-8 SQLCHAR sequence).
    void setString(ushort idx, Nullable!string value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_VARCHAR, SQL_C_CHAR, 0, 0);
            return;
        }
        _setString(idx, value.get);
    }

    /**
     * Binds a non-nullable null-terminated C string.
     *
     * Convenience wrapper: wraps the string in a Nullable and delegates.
     */
    void setCString(ushort idx, string s) @trusted {
        _setString(idx, s);
    }

    /// Binds a nullable wide (UTF-16) string.
    void setNString(ushort idx, Nullable!string value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_WVARCHAR, SQL_C_WCHAR, 0, 0);
            return;
        }
        import std.utf : toUTF16;
        wstring ws  = toUTF16(value.get);
        // Store as raw wchar bytes + null terminator
        ubyte[] buf = new ubyte[(ws.length + 1) * wchar.sizeof];
        (cast(wchar[])buf)[0 .. ws.length] = ws[];
        (cast(wchar[])buf)[ws.length]      = 0;

        _ensureCapacity(idx);
        with (_params[idx - 1]) {
            sqlType       = SQL_WVARCHAR;
            cType         = SQL_C_WCHAR;
            columnSize    = cast(SQLULEN)ws.length;
            decimalDigits = 0;
            data          = buf;
            indicator     = SQL_NTS;
        }
    }

    // ── Binary ────────────────────────────────────────────────────────────────

    /// Binds nullable binary data.
    void setBinary(ushort idx, Nullable!(ubyte[]) value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_VARBINARY, SQL_C_BINARY, 0, 0);
            return;
        }
        ubyte[] v = value.get.dup;
        _ensureCapacity(idx);
        with (_params[idx - 1]) {
            sqlType       = SQL_VARBINARY;
            cType         = SQL_C_BINARY;
            columnSize    = cast(SQLULEN)v.length;
            decimalDigits = 0;
            data          = v;
            indicator     = cast(SQLLEN)v.length;
        }
    }

    /**
     * Binds a raw byte sequence.
     *
     * Params:
     *   idx  = Parameter index (1-based).
     *   data = Pointer to the data.
     *   size = Number of bytes.
     */
    void setBytes(ushort idx, const(void)* data, size_t size) @trusted {
        ubyte[] copy = (cast(const(ubyte)*)data)[0 .. size].dup;
        _ensureCapacity(idx);
        with (_params[idx - 1]) {
            sqlType       = SQL_VARBINARY;
            cType         = SQL_C_BINARY;
            columnSize    = cast(SQLULEN)size;
            decimalDigits = 0;
            this.data     = copy;
            indicator     = cast(SQLLEN)size;
        }
    }

    // ── Date / time ───────────────────────────────────────────────────────────

    /// Binds a nullable Date.
    void setDate(ushort idx, Nullable!Date value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_TYPE_DATE, SQL_C_TYPE_DATE, 10, 0);
            return;
        }
        SQL_DATE_STRUCT ds;
        ds.year  = cast(SQLSMALLINT)value.get.year;
        ds.month = cast(SQLUSMALLINT)value.get.month;
        ds.day   = cast(SQLUSMALLINT)value.get.day;
        _setFixed(idx, SQL_TYPE_DATE, SQL_C_TYPE_DATE, 10, 0,
                  &ds, SQL_DATE_STRUCT.sizeof);
    }

    /// Binds a nullable TimeOfDay.
    void setTime(ushort idx, Nullable!TimeOfDay value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_TYPE_TIME, SQL_C_TYPE_TIME, 8, 0);
            return;
        }
        SQL_TIME_STRUCT ts;
        ts.hour   = cast(SQLUSMALLINT)value.get.hour;
        ts.minute = cast(SQLUSMALLINT)value.get.minute;
        ts.second = cast(SQLUSMALLINT)value.get.second;
        _setFixed(idx, SQL_TYPE_TIME, SQL_C_TYPE_TIME, 8, 0,
                  &ts, SQL_TIME_STRUCT.sizeof);
    }

    /// Binds a nullable DateTime (timestamp).
    void setTimestamp(ushort idx, Nullable!DateTime value) @trusted {
        if (value.isNull) {
            _setNull(idx, SQL_TYPE_TIMESTAMP, SQL_C_TYPE_TIMESTAMP, 19, 3);
            return;
        }
        SQL_TIMESTAMP_STRUCT ts;
        ts.year     = cast(SQLSMALLINT) value.get.year;
        ts.month    = cast(SQLUSMALLINT)value.get.month;
        ts.day      = cast(SQLUSMALLINT)value.get.day;
        ts.hour     = cast(SQLUSMALLINT)value.get.hour;
        ts.minute   = cast(SQLUSMALLINT)value.get.minute;
        ts.second   = cast(SQLUSMALLINT)value.get.second;
        ts.fraction = 0;
        _setFixed(idx, SQL_TYPE_TIMESTAMP, SQL_C_TYPE_TIMESTAMP, 19, 3,
                  &ts, SQL_TIMESTAMP_STRUCT.sizeof);
    }

    // ── Parameter management ──────────────────────────────────────────────────

    /// Resets all parameter bindings.
    void clearParameters() @safe {
        _params.length = 0;
        SQLFreeStmt(_hstmt, SQL_RESET_PARAMS);
    }

    // ── Batch support ─────────────────────────────────────────────────────────

    /**
     * Saves the current parameter set for batch execution.
     *
     * Call setXxx() for each parameter, then addBatch(), then repeat.
     * Finish with executeBatch().
     */
    void addBatch() @safe {
        _batch ~= _params.dup;
    }

    /**
     * Executes all parameter sets stored by addBatch() sequentially.
     *
     * Each set is bound and executed individually.
     * Clears the batch on completion.
     *
     * Throws: OdbcException if any execution fails.
     */
    void executeBatch() @trusted {
        foreach (paramSet; _batch) {
            OdbcParam[] saved = _params;
            _params = paramSet;
            _bindAndExecute();
            _params = saved;
        }
        _batch.length = 0;
    }

    /// Discards all stored batch parameter sets without executing them.
    void clearBatch() @safe {
        _batch.length = 0;
    }

    /// Returns the approximate number of bytes stored in the current batch.
    size_t getBatchDataSize() const @safe {
        size_t total = 0;
        foreach (ref ps; _batch) {
            foreach (ref p; ps) {
                total += p.data.length + SQLLEN.sizeof;
            }
        }
        return total;
    }

    // ── Query execution ───────────────────────────────────────────────────────

    /**
     * Executes the prepared query with the currently bound parameters.
     *
     * Returns: An OdbcResultSet positioned before the first row.
     * Throws:  OdbcException on failure.
     */
    OdbcResultSet executeQuery() @trusted {
        _bindAndExecute();
        return OdbcResultSet.fromStatement(_hstmt);
    }

    /**
     * Executes the prepared UPDATE/INSERT/DELETE with the currently bound
     * parameters.
     *
     * Returns: Number of affected rows.
     * Throws:  OdbcException on failure.
     */
    size_t executeUpdate() @trusted {
        _bindAndExecute();
        SQLLEN rowCount = 0;
        SQLRETURN rc = SQLRowCount(_hstmt, &rowCount);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLRowCount");
        return rowCount >= 0 ? cast(size_t)rowCount : 0;
    }

    // ── Metadata ──────────────────────────────────────────────────────────────

    /// Returns metadata about the columns that executeQuery() will produce.
    OdbcResultSetMetaData getMetaData() @trusted {
        return OdbcResultSetMetaData.fromStatement(_hstmt);
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    ~this() @trusted {
        if (_hstmt !is null) {
            SQLFreeHandle(SQL_HANDLE_STMT, _hstmt);
            _hstmt = null;
        }
    }

    // ── Private ───────────────────────────────────────────────────────────────

private:
    SQLHSTMT    _hstmt;
    OdbcParam[] _params;
    OdbcParam[][] _batch;

    package this(SQLHSTMT hstmt) @safe {
        _hstmt = hstmt;
    }

    // Grow _params to hold index idx (1-based)
    void _ensureCapacity(ushort idx) @safe {
        if (_params.length < idx)
            _params.length = idx;
    }

    void _setNull(ushort idx,
                  SQLSMALLINT sqlType, SQLSMALLINT cType,
                  SQLULEN colSize, SQLSMALLINT decDigits) @trusted {
        _ensureCapacity(idx);
        with (_params[idx - 1]) {
            this.sqlType       = sqlType;
            this.cType         = cType;
            this.columnSize    = colSize;
            this.decimalDigits = decDigits;
            this.data          = null;
            this.indicator     = SQL_NULL_DATA;
        }
    }

    void _setFixed(ushort idx,
                   SQLSMALLINT sqlType, SQLSMALLINT cType,
                   SQLULEN colSize, SQLSMALLINT decDigits,
                   const(void)* src, size_t srcLen) @trusted {
        _ensureCapacity(idx);
        ubyte[] buf = new ubyte[srcLen];
        buf[] = (cast(const(ubyte)*)src)[0 .. srcLen];
        with (_params[idx - 1]) {
            this.sqlType       = sqlType;
            this.cType         = cType;
            this.columnSize    = colSize;
            this.decimalDigits = decDigits;
            this.data          = buf;
            this.indicator     = cast(SQLLEN)srcLen;
        }
    }

    void _setString(ushort idx, string s) @trusted {
        // Store as null-terminated SQLCHAR[] (UTF-8)
        ubyte[] buf = new ubyte[s.length + 1];
        buf[0 .. s.length] = cast(const(ubyte)[])s[];
        buf[s.length]      = 0;
        _ensureCapacity(idx);
        with (_params[idx - 1]) {
            sqlType       = SQL_VARCHAR;
            cType         = SQL_C_CHAR;
            columnSize    = cast(SQLULEN)s.length;
            decimalDigits = 0;
            data          = buf;
            indicator     = SQL_NTS;
        }
    }

    // Bind all parameters and execute.
    void _bindAndExecute() @trusted {
        // Reset prior bindings
        SQLFreeStmt(_hstmt, SQL_RESET_PARAMS);
        SQLCloseCursor(_hstmt);

        foreach (i, ref p; _params) {
            ushort paramNo = cast(ushort)(i + 1);
            SQLPOINTER valPtr = (p.indicator == SQL_NULL_DATA || p.data is null)
                                ? null
                                : cast(SQLPOINTER)p.data.ptr;

            SQLRETURN rc = SQLBindParameter(
                _hstmt, paramNo,
                SQL_PARAM_INPUT,
                p.cType, p.sqlType,
                p.columnSize, p.decimalDigits,
                valPtr,
                p.data !is null ? cast(SQLLEN)p.data.length : 0,
                &p.indicator);
            checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLBindParameter");
        }

        SQLRETURN rc = SQLExecute(_hstmt);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLExecute");
    }
}
