/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.statement;

import uim.odbc.bindings.sql;
import uim.odbc.classes.exception;
import uim.odbc.classes.resultset;
import uim.odbc.classes.resultsetmetadata;

import std.string : toStringz;

// ---------------------------------------------------------------------------
// OdbcStatement – executes ad-hoc SQL strings.
// ---------------------------------------------------------------------------

/**
 * Executes SQL statements that do not require parameter binding.
 *
 * For parameterised queries use OdbcPreparedStatement instead.
 * Obtain an instance from OdbcConnection.createStatement().
 *
 * Example:
 * ---
 * auto stmt = conn.createStatement();
 * auto rs   = stmt.executeQuery("SELECT id, name FROM users");
 * while (rs.next()) { ... }
 * rs.close();
 * stmt.close();
 * ---
 */
class OdbcStatement {

    // ── Query execution ───────────────────────────────────────────────────────

    /**
     * Executes a SELECT query and returns the result set.
     *
     * The caller is responsible for calling OdbcResultSet.close() when done.
     *
     * Params:
     *   sql = The SQL SELECT statement to execute.
     * Returns: An OdbcResultSet positioned before the first row.
     * Throws:  OdbcException on failure.
     */
    OdbcResultSet executeQuery(string sql) @trusted {
        _closeOpenCursor();
        auto sqlZ = sql.toStringz;
        SQLRETURN rc = SQLExecDirect(_hstmt,
            cast(SQLCHAR*)sqlZ, cast(SQLINTEGER)sql.length);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLExecDirect(query)");
        return OdbcResultSet.fromStatement(_hstmt);
    }

    /**
     * Executes an UPDATE, INSERT, DELETE or DDL statement.
     *
     * Params:
     *   sql = The SQL statement.
     * Returns: The number of affected rows (0 for DDL statements).
     * Throws:  OdbcException on failure.
     */
    size_t executeUpdate(string sql) @trusted {
        _closeOpenCursor();
        auto sqlZ = sql.toStringz;
        SQLRETURN rc = SQLExecDirect(_hstmt,
            cast(SQLCHAR*)sqlZ, cast(SQLINTEGER)sql.length);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLExecDirect(update)");

        SQLLEN rowCount = 0;
        rc = SQLRowCount(_hstmt, &rowCount);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLRowCount");
        return rowCount >= 0 ? cast(size_t)rowCount : 0;
    }

    /**
     * Executes any SQL statement and returns true if the first result is a
     * result set, false if it is an update count or there are no results.
     */
    bool execute(string sql) @trusted {
        _closeOpenCursor();
        auto sqlZ = sql.toStringz;
        SQLRETURN rc = SQLExecDirect(_hstmt,
            cast(SQLCHAR*)sqlZ, cast(SQLINTEGER)sql.length);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLExecDirect");

        SQLSMALLINT nCols;
        rc = SQLNumResultCols(_hstmt, &nCols);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "SQLNumResultCols");
        return nCols > 0;
    }

    // ── Statement attributes ──────────────────────────────────────────────────

    /// Sets the query timeout in seconds (0 = infinite).
    void setQueryTimeout(uint seconds) @trusted {
        SQLRETURN rc = SQLSetStmtAttr(_hstmt, SQL_ATTR_QUERY_TIMEOUT,
            cast(SQLPOINTER)cast(SQLULEN)seconds, 0);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "setQueryTimeout");
    }

    /// Returns the query timeout in seconds.
    uint getQueryTimeout() @trusted {
        SQLULEN val;
        SQLRETURN rc = SQLGetStmtAttr(_hstmt, SQL_ATTR_QUERY_TIMEOUT,
            cast(SQLPOINTER)&val, 0, null);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "getQueryTimeout");
        return cast(uint)val;
    }

    /// Sets the maximum number of rows to return (0 = all rows).
    void setMaxRows(ulong maxRows) @trusted {
        SQLRETURN rc = SQLSetStmtAttr(_hstmt, SQL_ATTR_MAX_ROWS,
            cast(SQLPOINTER)cast(SQLULEN)maxRows, 0);
        checkOdbc(rc, SQL_HANDLE_STMT, _hstmt, "setMaxRows");
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    /**
     * Closes the cursor and discards any pending results.
     *
     * The statement can be reused after calling close().
     */
    void close() @trusted {
        if (_hstmt !is null)
            SQLCloseCursor(_hstmt);
    }

    ~this() @trusted {
        if (_hstmt !is null) {
            SQLFreeHandle(SQL_HANDLE_STMT, _hstmt);
            _hstmt = null;
        }
    }

    // ── Package-level access ──────────────────────────────────────────────────

    package SQLHSTMT handle() pure nothrow @safe { return _hstmt; }

    // ── Private ───────────────────────────────────────────────────────────────

private:
    SQLHSTMT _hstmt;

    package this(SQLHSTMT hstmt) @safe { _hstmt = hstmt; }

    void _closeOpenCursor() @trusted {
        // Close any previously open cursor before re-executing
        SQLCloseCursor(_hstmt);
        // Ignore errors – there may simply be no open cursor
    }
}
