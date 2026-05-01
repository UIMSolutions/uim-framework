/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.resultset;

import uim.odbc.bindings.sql;
import uim.odbc.classes.exception;
import uim.odbc.classes.resultsetmetadata;
import uim.odbc.types;

import std.datetime : Date, TimeOfDay, DateTime;
import std.typecons  : Nullable, nullable;
import std.conv      : to;

// ---------------------------------------------------------------------------
// OdbcResultSet – iterates rows returned by a query.
// ---------------------------------------------------------------------------

/**
 * Represents the result set of an executed SQL query.
 *
 * Call next() in a loop to advance the cursor; retrieve column values via the
 * typed getXxx(columnIndex) methods.  Column indices are 1-based.
 *
 * The result set does NOT own the underlying statement handle; the owning
 * Statement or PreparedStatement manages its lifetime.
 *
 * Example:
 * ---
 * auto rs = ps.executeQuery();
 * while (rs.next()) {
 *     auto id  = rs.getInt(1);
 *     auto name = rs.getString(2);
 * }
 * rs.close();
 * ---
 */
class OdbcResultSet {

    /// Sentinel value returned by getBinaryLength/getStringLength when the
    /// value is NULL.
    enum size_t NULL_DATA     = cast(size_t)-1;
    /// Sentinel value when the driver cannot determine the length.
    enum size_t UNKNOWN_LENGTH = cast(size_t)-2;

    // ── Cursor movement ───────────────────────────────────────────────────────

    /**
     * Advances to the next row.
     *
     * Returns: true if a row was fetched, false if there are no more rows.
     * Throws:  OdbcException on failure.
     */
    bool next() @trusted {
        SQLRETURN rc = SQLFetch(_hstmt);
        if (rc == SQL_NO_DATA) return false;
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLFetch");
        return true;
    }

    /**
     * Closes the cursor, discarding any unfetched rows.
     *
     * The result set may no longer be used after calling close().
     */
    void close() @trusted {
        if (_hstmt !is null) {
            SQLCloseCursor(_hstmt);
        }
    }

    // ── Metadata ──────────────────────────────────────────────────────────────

    /**
     * Returns metadata describing the columns of this result set.
     */
    OdbcResultSetMetaData getMetaData() @trusted {
        return OdbcResultSetMetaData.fromStatement(_hstmt);
    }

    // ── Typed getters ─────────────────────────────────────────────────────────
    //
    // All getters return Nullable!T so the caller can distinguish NULL from a
    // zero/empty value.  A null Nullable means the column contains SQL NULL.

    /// Gets the value of `col` as a nullable bool.
    Nullable!bool getBoolean(ushort col) @trusted {
        SQLLEN ind;
        SQLCHAR val;
        _getData(col, SQL_C_BIT, &val, SQLCHAR.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!bool.init;
        return nullable(val != 0);
    }

    /// Gets the value of `col` as a nullable signed byte.
    Nullable!byte getByte(ushort col) @trusted {
        SQLLEN ind;
        SQLSCHAR val;
        _getData(col, SQL_C_STINYINT, &val, SQLSCHAR.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!byte.init;
        return nullable(cast(byte)val);
    }

    /// Gets the value of `col` as a nullable unsigned byte.
    Nullable!ubyte getUByte(ushort col) @trusted {
        SQLLEN ind;
        SQLCHAR val;
        _getData(col, SQL_C_UTINYINT, &val, SQLCHAR.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!ubyte.init;
        return nullable(cast(ubyte)val);
    }

    /// Gets the value of `col` as a nullable signed short.
    Nullable!short getShort(ushort col) @trusted {
        SQLLEN ind;
        SQLSMALLINT val;
        _getData(col, SQL_C_SSHORT, &val, SQLSMALLINT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!short.init;
        return nullable(cast(short)val);
    }

    /// Gets the value of `col` as a nullable unsigned short.
    Nullable!ushort getUShort(ushort col) @trusted {
        SQLLEN ind;
        SQLUSMALLINT val;
        _getData(col, SQL_C_USHORT, &val, SQLUSMALLINT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!ushort.init;
        return nullable(cast(ushort)val);
    }

    /// Gets the value of `col` as a nullable signed int.
    Nullable!int getInt(ushort col) @trusted {
        SQLLEN ind;
        SQLINTEGER val;
        _getData(col, SQL_C_SLONG, &val, SQLINTEGER.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!int.init;
        return nullable(cast(int)val);
    }

    /// Gets the value of `col` as a nullable unsigned int.
    Nullable!uint getUInt(ushort col) @trusted {
        SQLLEN ind;
        SQLUINTEGER val;
        _getData(col, SQL_C_ULONG, &val, SQLUINTEGER.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!uint.init;
        return nullable(cast(uint)val);
    }

    /// Gets the value of `col` as a nullable signed long.
    Nullable!long getLong(ushort col) @trusted {
        SQLLEN ind;
        SQLBIGINT val;
        _getData(col, SQL_C_SBIGINT, &val, SQLBIGINT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!long.init;
        return nullable(cast(long)val);
    }

    /// Gets the value of `col` as a nullable unsigned long.
    Nullable!ulong getULong(ushort col) @trusted {
        SQLLEN ind;
        SQLUBIGINT val;
        _getData(col, SQL_C_UBIGINT, &val, SQLUBIGINT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!ulong.init;
        return nullable(cast(ulong)val);
    }

    /// Gets the value of `col` as a nullable float.
    Nullable!float getFloat(ushort col) @trusted {
        SQLLEN ind;
        SQLREAL val;
        _getData(col, SQL_C_FLOAT, &val, SQLREAL.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!float.init;
        return nullable(cast(float)val);
    }

    /// Gets the value of `col` as a nullable double.
    Nullable!double getDouble(ushort col) @trusted {
        SQLLEN ind;
        SQLDOUBLE val;
        _getData(col, SQL_C_DOUBLE, &val, SQLDOUBLE.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!double.init;
        return nullable(cast(double)val);
    }

    /// Gets the value of `col` as a nullable OdbcDecimal.
    Nullable!OdbcDecimal getDecimal(ushort col) @trusted {
        SQLLEN ind;
        SQL_NUMERIC_STRUCT ns;
        _getData(col, SQL_C_NUMERIC, &ns, SQL_NUMERIC_STRUCT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!OdbcDecimal.init;

        // Convert SQL_NUMERIC_STRUCT to OdbcDecimal
        // The val field holds the magnitude as a little-endian 128-bit integer
        ulong lo = 0, hi = 0;
        foreach (i; 0 .. 8) {
            lo |= cast(ulong)ns.val[i] << (i * 8);
        }
        foreach (i; 0 .. 8) {
            hi |= cast(ulong)ns.val[8 + i] << (i * 8);
        }
        // For values that fit in 63 bits, use the lo part
        long signedVal = ns.sign == 1 ? cast(long)lo : -cast(long)lo;
        auto d = OdbcDecimal.fromInt(signedVal, ns.precision, ns.scale);
        return nullable(d);
    }

    /// Gets the value of `col` as a nullable Date.
    Nullable!Date getDate(ushort col) @trusted {
        SQLLEN ind;
        SQL_DATE_STRUCT ds;
        _getData(col, SQL_C_TYPE_DATE, &ds, SQL_DATE_STRUCT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!Date.init;
        return nullable(Date(ds.year, ds.month, ds.day));
    }

    /// Gets the value of `col` as a nullable TimeOfDay.
    Nullable!TimeOfDay getTime(ushort col) @trusted {
        SQLLEN ind;
        SQL_TIME_STRUCT ts;
        _getData(col, SQL_C_TYPE_TIME, &ts, SQL_TIME_STRUCT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!TimeOfDay.init;
        return nullable(TimeOfDay(ts.hour, ts.minute, ts.second));
    }

    /// Gets the value of `col` as a nullable DateTime (timestamp).
    Nullable!DateTime getTimestamp(ushort col) @trusted {
        SQLLEN ind;
        SQL_TIMESTAMP_STRUCT ts;
        _getData(col, SQL_C_TYPE_TIMESTAMP, &ts, SQL_TIMESTAMP_STRUCT.sizeof, &ind);
        if (ind == SQL_NULL_DATA) return Nullable!DateTime.init;
        return nullable(DateTime(ts.year, ts.month, ts.day,
                                 ts.hour, ts.minute, ts.second));
    }

    /**
     * Gets the value of `col` as a nullable string.
     *
     * Uses an iterative SQLGetData loop to handle values larger than the
     * internal buffer.
     */
    Nullable!string getString(ushort col) @trusted {
        return _getStringData(col, SQL_C_CHAR);
    }

    /**
     * Gets the value of `col` as a nullable wide string (UTF-16).
     *
     * The returned string is decoded from UTF-16 to D's native UTF-8.
     */
    Nullable!string getNString(ushort col) @trusted {
        // Read as UTF-16 then transcode to string
        auto ws = _getNStringData(col);
        if (ws.isNull) return Nullable!string.init;
        import std.utf : toUTF8;
        return nullable(toUTF8(ws.get));
    }

    /**
     * Gets the value of `col` as nullable binary data.
     */
    Nullable!(ubyte[]) getBinary(ushort col) @trusted {
        return _getBinaryData(col);
    }

    // ── Streaming / low-level getters ─────────────────────────────────────────

    /**
     * Returns the byte length of the binary data in `col`, or NULL_DATA if
     * the column is NULL, or UNKNOWN_LENGTH if the driver cannot determine it.
     */
    size_t getBinaryLength(ushort col) @trusted {
        SQLLEN ind;
        // Call with zero-length buffer just to read the indicator
        SQLRETURN rc = SQLGetData(_hstmt, col, SQL_C_BINARY, null, 0, &ind);
        if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO && rc != SQL_NO_DATA)
            checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getBinaryLength");
        if (ind == SQL_NULL_DATA)     return NULL_DATA;
        if (ind == SQL_NO_TOTAL)      return UNKNOWN_LENGTH;
        return cast(size_t)ind;
    }

    /**
     * Reads up to `size` bytes of binary data from `col` into `buf`.
     *
     * Params:
     *   col  = Column index (1-based).
     *   buf  = Pointer to the destination buffer.
     *   size = Maximum number of bytes to read.
     */
    void getBinaryData(ushort col, void* buf, size_t size) @trusted {
        SQLLEN ind;
        SQLRETURN rc = SQLGetData(_hstmt, col, SQL_C_BINARY,
            cast(SQLPOINTER)buf, cast(SQLLEN)size, &ind);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getBinaryData");
    }

    /**
     * Returns the character length of the string in `col` (without null
     * terminator), or NULL_DATA / UNKNOWN_LENGTH.
     */
    size_t getStringLength(ushort col) @trusted {
        SQLLEN ind;
        SQLRETURN rc = SQLGetData(_hstmt, col, SQL_C_CHAR, null, 0, &ind);
        if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO && rc != SQL_NO_DATA)
            checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getStringLength");
        if (ind == SQL_NULL_DATA) return NULL_DATA;
        if (ind == SQL_NO_TOTAL)  return UNKNOWN_LENGTH;
        return cast(size_t)ind;
    }

    // ── Package-level factory ─────────────────────────────────────────────────

    package static OdbcResultSet fromStatement(SQLHSTMT hstmt) @safe {
        return new OdbcResultSet(hstmt);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

private:
    SQLHSTMT _hstmt;

    this(SQLHSTMT hstmt) @safe { _hstmt = hstmt; }

    // Generic fixed-size data fetch via SQLGetData.
    void _getData(ushort col, SQLSMALLINT cType,
                  void* buf, size_t bufLen, SQLLEN* indicator) @trusted {
        SQLRETURN rc = SQLGetData(_hstmt, col, cType,
            cast(SQLPOINTER)buf, cast(SQLLEN)bufLen, indicator);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLGetData");
    }

    // String fetch: iterates chunks until SQL_SUCCESS (no more data).
    Nullable!string _getStringData(ushort col, SQLSMALLINT cType) @trusted {
        enum CHUNK = 4096;
        char[CHUNK] buf;
        string result;
        bool firstChunk = true;

        while (true) {
            SQLLEN ind;
            SQLRETURN rc = SQLGetData(_hstmt, col, cType,
                cast(SQLPOINTER)buf.ptr, cast(SQLLEN)buf.sizeof, &ind);

            if (rc == SQL_NO_DATA) break;
            if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
                checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getString");

            if (firstChunk && ind == SQL_NULL_DATA)
                return Nullable!string.init;
            firstChunk = false;

            if (rc == SQL_SUCCESS) {
                // All remaining data was written
                size_t written = (ind >= 0 && cast(size_t)ind < buf.sizeof)
                                 ? cast(size_t)ind
                                 : buf.sizeof - 1;
                result ~= buf[0 .. written];
                break;
            } else {
                // SQL_SUCCESS_WITH_INFO: truncation; CHUNK-1 chars were written
                result ~= buf[0 .. CHUNK - 1];
            }
        }
        return nullable(result);
    }

    // Wide-string fetch returning wchar[].
    Nullable!(wchar[]) _getNStringData(ushort col) @trusted {
        enum WCHUNK = 2048;  // wchar count
        wchar[WCHUNK] buf;
        wchar[] result;
        bool firstChunk = true;

        while (true) {
            SQLLEN ind;
            SQLRETURN rc = SQLGetData(_hstmt, col, SQL_C_WCHAR,
                cast(SQLPOINTER)buf.ptr,
                cast(SQLLEN)(buf.sizeof),  // byte length of buffer
                &ind);

            if (rc == SQL_NO_DATA) break;
            if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
                checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getNString");

            if (firstChunk && ind == SQL_NULL_DATA)
                return Nullable!(wchar[]).init;
            firstChunk = false;

            if (rc == SQL_SUCCESS) {
                size_t wchars = (ind >= 0)
                    ? cast(size_t)(ind / wchar.sizeof)
                    : WCHUNK - 1;
                result ~= buf[0 .. wchars];
                break;
            } else {
                result ~= buf[0 .. WCHUNK - 1];
            }
        }
        return nullable(result);
    }

    // Binary data fetch.
    Nullable!(ubyte[]) _getBinaryData(ushort col) @trusted {
        enum BCHUNK = 4096;
        ubyte[BCHUNK] buf;
        ubyte[] result;
        bool firstChunk = true;

        while (true) {
            SQLLEN ind;
            SQLRETURN rc = SQLGetData(_hstmt, col, SQL_C_BINARY,
                cast(SQLPOINTER)buf.ptr, cast(SQLLEN)buf.sizeof, &ind);

            if (rc == SQL_NO_DATA) break;
            if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
                checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getBinary");

            if (firstChunk && ind == SQL_NULL_DATA)
                return Nullable!(ubyte[]).init;
            firstChunk = false;

            if (rc == SQL_SUCCESS) {
                size_t written = (ind >= 0 && cast(size_t)ind <= buf.sizeof)
                                 ? cast(size_t)ind
                                 : buf.sizeof;
                result ~= buf[0 .. written];
                break;
            } else {
                result ~= buf[0 .. BCHUNK];
            }
        }
        return nullable(result.dup);
    }
}
