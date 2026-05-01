/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.resultsetmetadata;

import uim.odbc.bindings.sql;
import uim.odbc.classes.exception;
import uim.odbc.enumerations.types;

import std.conv : to;

// ---------------------------------------------------------------------------
// OdbcResultSetMetaData – describes the columns of a result set.
// ---------------------------------------------------------------------------

/**
 * Provides metadata about the columns returned by a query.
 *
 * Obtained by calling OdbcResultSet.getMetaData().
 *
 * Column indices are 1-based to match ODBC conventions.
 */
class OdbcResultSetMetaData {

    // ── Column count ──────────────────────────────────────────────────────────

    /// Returns the number of columns in the result set.
    ushort columnCount() const pure nothrow @safe {
        return _count;
    }

    // ── Per-column info ───────────────────────────────────────────────────────

    /**
     * Returns the name of the specified column.
     *
     * Params:
     *   col = Column index (1-based).
     */
    string columnName(ushort col) const pure @safe {
        _checkIndex(col);
        return _cols[col - 1].name;
    }

    /**
     * Returns the SQL data type of the specified column.
     *
     * Params:
     *   col = Column index (1-based).
     */
    SQLDataType columnType(ushort col) const pure @safe {
        _checkIndex(col);
        return _cols[col - 1].dataType;
    }

    /**
     * Returns the raw ODBC SQL type code of the specified column.
     *
     * Params:
     *   col = Column index (1-based).
     */
    short columnTypeCode(ushort col) const pure @safe {
        _checkIndex(col);
        return cast(short)_cols[col - 1].dataType;
    }

    /**
     * Returns the column size (precision for numeric types, max chars for
     * string types).
     *
     * Params:
     *   col = Column index (1-based).
     */
    ulong columnSize(ushort col) const pure @safe {
        _checkIndex(col);
        return _cols[col - 1].size;
    }

    /**
     * Returns the number of decimal digits for numeric columns.
     *
     * Params:
     *   col = Column index (1-based).
     */
    short decimalDigits(ushort col) const pure @safe {
        _checkIndex(col);
        return _cols[col - 1].decimalDigits;
    }

    /**
     * Returns the nullability of the specified column.
     *
     * Params:
     *   col = Column index (1-based).
     */
    ColumnNullable nullable(ushort col) const pure @safe {
        _checkIndex(col);
        return _cols[col - 1].nullable;
    }

    // ── Package-level factory ─────────────────────────────────────────────────

    package static OdbcResultSetMetaData fromStatement(SQLHSTMT hstmt) @trusted {
        SQLSMALLINT count;
        SQLRETURN rc = SQLNumResultCols(hstmt, &count);
        checkOdbc(rc, SQL_HANDLE_STMT, hstmt, "SQLNumResultCols");

        auto meta = new OdbcResultSetMetaData(cast(ushort)count);

        foreach (i; 0 .. count) {
            ushort colNo = cast(ushort)(i + 1);

            SQLCHAR[256]  name;
            SQLSMALLINT   nameLen;
            SQLSMALLINT   dataType;
            SQLULEN       colSize;
            SQLSMALLINT   decDigits;
            SQLSMALLINT   nullableCode;

            rc = SQLDescribeCol(hstmt, colNo,
                name.ptr, cast(SQLSMALLINT)name.sizeof, &nameLen,
                &dataType, &colSize, &decDigits, &nullableCode);
            checkOdbc(rc, SQL_HANDLE_STMT, hstmt, "SQLDescribeCol");

            ColumnNullable cn;
            switch (nullableCode) {
                case SQL_NO_NULLS:         cn = ColumnNullable.NO_NULLS; break;
                case SQL_NULLABLE:         cn = ColumnNullable.NULLABLE; break;
                default:                   cn = ColumnNullable.UNKNOWN;  break;
            }

            meta._cols[i] = ColInfo(
                cast(string)name[0 .. nameLen].idup,
                cast(SQLDataType)dataType,
                cast(ulong)colSize,
                decDigits,
                cn);
        }

        return meta;
    }

    // ── Private ───────────────────────────────────────────────────────────────

private:
    struct ColInfo {
        string       name;
        SQLDataType  dataType;
        ulong        size;
        short        decimalDigits;
        ColumnNullable nullable;
    }

    ushort    _count;
    ColInfo[] _cols;

    this(ushort count) @safe {
        _count = count;
        _cols  = new ColInfo[count];
    }

    void _checkIndex(ushort col) const pure @safe {
        if (col < 1 || col > _count)
            throw new OdbcException("Column index " ~ col.to!string
                                    ~ " out of range [1.." ~ _count.to!string ~ "]");
    }
}
