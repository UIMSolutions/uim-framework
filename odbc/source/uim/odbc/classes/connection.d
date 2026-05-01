/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.connection;

import uim.odbc.bindings.sql;
import uim.odbc.classes.exception;
import uim.odbc.classes.statement;
import uim.odbc.classes.preparedstatement;
import uim.odbc.enumerations.types;

import std.string : toStringz;
import std.conv   : to;

// ---------------------------------------------------------------------------
// OdbcConnection – wraps an ODBC SQLHDBC handle.
// ---------------------------------------------------------------------------

/**
 * Represents a database connection.
 *
 * A connection is obtained by calling OdbcEnvironment.createConnection().
 * After creation it must be connected using connect() or connectString().
 * Auto-commit defaults to on; for manual transactions call setAutoCommit(false).
 *
 * Example:
 * ---
 * auto env  = OdbcEnvironment.create();
 * auto conn = env.createConnection();
 * conn.connect("myDSN", "user", "password");
 * conn.setAutoCommit(false);
 *
 * auto ps = conn.prepareStatement("INSERT INTO t(id, val) VALUES (?, ?)");
 * ps.setInt(1, nullable(42));
 * ps.setString(2, nullable("hello"));
 * ps.executeUpdate();
 * conn.commit();
 *
 * conn.disconnect();
 * ---
 */
class OdbcConnection {

    // ── Connection ────────────────────────────────────────────────────────────

    /**
     * Connects to a database using a data source name (DSN).
     *
     * Params:
     *   dsn      = The data source name.
     *   user     = The user name (may be empty string).
     *   password = The password (may be empty string).
     * Throws: OdbcException on failure.
     */
    void connect(string dsn, string user, string password) @trusted {
        if (_connected)
            throw new OdbcException("Already connected – call disconnect() first");

        auto dsnZ  = dsn.toStringz;
        auto userZ = user.toStringz;
        auto passZ = password.toStringz;

        SQLRETURN rc = SQLConnect(
            _hdbc,
            cast(SQLCHAR*)dsnZ,  cast(SQLSMALLINT)dsn.length,
            cast(SQLCHAR*)userZ, cast(SQLSMALLINT)user.length,
            cast(SQLCHAR*)passZ, cast(SQLSMALLINT)password.length);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "SQLConnect");
        _connected = true;
    }

    /**
     * Connects using an ODBC driver-specific connection string.
     *
     * Params:
     *   connString = Driver connection string, e.g.
     *                "Driver={PostgreSQL};Server=localhost;Database=mydb;...".
     * Throws: OdbcException on failure.
     */
    void connectString(string connString) @trusted {
        if (_connected)
            throw new OdbcException("Already connected – call disconnect() first");

        auto csZ = connString.toStringz;
        SQLCHAR[1024] outStr;
        SQLSMALLINT   outLen;

        SQLRETURN rc = SQLDriverConnect(
            _hdbc, null,
            cast(SQLCHAR*)csZ, cast(SQLSMALLINT)connString.length,
            outStr.ptr, cast(SQLSMALLINT)outStr.sizeof, &outLen,
            SQL_DRIVER_NOPROMPT);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "SQLDriverConnect");
        _connected = true;
    }

    /**
     * Disconnects from the database.
     *
     * Any uncommitted transactions are rolled back by the driver.
     * Throws: OdbcException on failure.
     */
    void disconnect() @trusted {
        if (!_connected) return;
        SQLRETURN rc = SQLDisconnect(_hdbc);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "SQLDisconnect");
        _connected = false;
    }

    /**
     * Returns true if this connection is currently connected.
     *
     * Note: this reflects whether connect() has been called and disconnect()
     * has not.  It does NOT probe the network to verify liveness; use isValid()
     * for that.
     */
    bool connected() const pure nothrow @safe {
        return _connected;
    }

    /**
     * Probes the connection to check whether it is still alive.
     *
     * Executes a lightweight ODBC query (SQL_ATTR_CONNECTION_DEAD) to check
     * whether the connection is still usable.
     *
     * Returns: true if the connection is alive.
     */
    bool isValid() @trusted {
        if (!_connected) return false;
        SQLUINTEGER dead;
        SQLRETURN rc = SQLGetConnectAttr(_hdbc, cast(SQLINTEGER)1209,  // SQL_ATTR_CONNECTION_DEAD = 1209
            cast(SQLPOINTER)&dead, cast(SQLINTEGER)SQLUINTEGER.sizeof, null);
        if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
            return false;
        return dead == 0;  // SQL_CD_FALSE = 0
    }

    // ── Destructor ────────────────────────────────────────────────────────────

    ~this() @trusted {
        if (_connected) {
            try { SQLDisconnect(_hdbc); } catch (Exception) {}
        }
        if (_hdbc !is null) {
            SQLFreeHandle(SQL_HANDLE_DBC, _hdbc);
            _hdbc = null;
        }
    }

    // ── Timeouts ──────────────────────────────────────────────────────────────

    /// Returns the connection timeout in seconds (0 = infinite).
    ulong getConnectionTimeout() @trusted {
        SQLUINTEGER val;
        SQLRETURN rc = SQLGetConnectAttr(_hdbc, SQL_ATTR_CONNECTION_TIMEOUT,
            cast(SQLPOINTER)&val, cast(SQLINTEGER)SQLUINTEGER.sizeof, null);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "getConnectionTimeout");
        return cast(ulong)val;
    }

    /// Sets the connection timeout in seconds (0 = infinite).
    void setConnectionTimeout(ulong seconds) @trusted {
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, SQL_ATTR_CONNECTION_TIMEOUT,
            cast(SQLPOINTER)cast(SQLUINTEGER)seconds, 0);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setConnectionTimeout");
    }

    /// Returns the login timeout in seconds (0 = infinite).
    ulong getLoginTimeout() @trusted {
        SQLUINTEGER val;
        SQLRETURN rc = SQLGetConnectAttr(_hdbc, SQL_ATTR_LOGIN_TIMEOUT,
            cast(SQLPOINTER)&val, cast(SQLINTEGER)SQLUINTEGER.sizeof, null);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "getLoginTimeout");
        return cast(ulong)val;
    }

    /// Sets the login timeout in seconds (0 = infinite).
    void setLoginTimeout(ulong seconds) @trusted {
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, SQL_ATTR_LOGIN_TIMEOUT,
            cast(SQLPOINTER)cast(SQLUINTEGER)seconds, 0);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setLoginTimeout");
    }

    // ── Auto-commit / transactions ────────────────────────────────────────────

    /// Returns true if auto-commit mode is enabled.
    bool getAutoCommit() @trusted {
        SQLUINTEGER val;
        SQLRETURN rc = SQLGetConnectAttr(_hdbc, SQL_ATTR_AUTOCOMMIT,
            cast(SQLPOINTER)&val, cast(SQLINTEGER)SQLUINTEGER.sizeof, null);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "getAutoCommit");
        return val != SQL_AUTOCOMMIT_OFF;
    }

    /**
     * Enables or disables auto-commit mode.
     *
     * When auto-commit is disabled, the application must call commit() or
     * rollback() to end each transaction.
     */
    void setAutoCommit(bool autoCommit) @trusted {
        SQLULEN val = autoCommit ? SQL_AUTOCOMMIT_ON : SQL_AUTOCOMMIT_OFF;
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, SQL_ATTR_AUTOCOMMIT,
            cast(SQLPOINTER)val, 0);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setAutoCommit");
    }

    /// Commits all pending changes to the database.
    void commit() @trusted {
        SQLRETURN rc = SQLEndTran(SQL_HANDLE_DBC, _hdbc, SQL_COMMIT);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "commit");
    }

    /// Rolls back all pending changes.
    void rollback() @trusted {
        SQLRETURN rc = SQLEndTran(SQL_HANDLE_DBC, _hdbc, SQL_ROLLBACK);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "rollback");
    }

    // ── Read-only mode ────────────────────────────────────────────────────────

    /// Returns true if the connection is in read-only mode.
    bool isReadOnly() @trusted {
        SQLUINTEGER val;
        SQLRETURN rc = SQLGetConnectAttr(_hdbc, SQL_ATTR_ACCESS_MODE,
            cast(SQLPOINTER)&val, cast(SQLINTEGER)SQLUINTEGER.sizeof, null);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "isReadOnly");
        return val == SQL_MODE_READ_ONLY;
    }

    /**
     * Puts the connection into read-only or read-write mode.
     *
     * Some drivers ignore this hint or only honour it before connecting.
     */
    void setReadOnly(bool readOnly) @trusted {
        SQLULEN val = readOnly ? SQL_MODE_READ_ONLY : SQL_MODE_READ_WRITE;
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, SQL_ATTR_ACCESS_MODE,
            cast(SQLPOINTER)val, 0);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setReadOnly");
    }

    // ── Transaction isolation ─────────────────────────────────────────────────

    /// Returns the current transaction isolation level.
    TransactionIsolationLevel getTransactionIsolation() @trusted {
        SQLUINTEGER val;
        SQLRETURN rc = SQLGetConnectAttr(_hdbc, SQL_ATTR_TXN_ISOLATION,
            cast(SQLPOINTER)&val, cast(SQLINTEGER)SQLUINTEGER.sizeof, null);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "getTransactionIsolation");
        switch (val) {
            case SQL_TXN_READ_UNCOMMITTED: return TransactionIsolationLevel.READ_UNCOMMITTED;
            case SQL_TXN_READ_COMMITTED:   return TransactionIsolationLevel.READ_COMMITTED;
            case SQL_TXN_REPEATABLE_READ:  return TransactionIsolationLevel.REPEATABLE_READ;
            case SQL_TXN_SERIALIZABLE:     return TransactionIsolationLevel.SERIALIZABLE;
            default:                        return TransactionIsolationLevel.NONE;
        }
    }

    /**
     * Sets the transaction isolation level.
     *
     * May only be called when no transactions are open.
     * Throws: OdbcException on failure.
     */
    void setTransactionIsolation(TransactionIsolationLevel level) @trusted {
        SQLULEN val;
        final switch (level) {
            case TransactionIsolationLevel.READ_UNCOMMITTED:
                val = SQL_TXN_READ_UNCOMMITTED; break;
            case TransactionIsolationLevel.READ_COMMITTED:
                val = SQL_TXN_READ_COMMITTED;   break;
            case TransactionIsolationLevel.REPEATABLE_READ:
                val = SQL_TXN_REPEATABLE_READ;  break;
            case TransactionIsolationLevel.SERIALIZABLE:
                val = SQL_TXN_SERIALIZABLE;     break;
            case TransactionIsolationLevel.NONE:
                return;  // no-op
        }
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, SQL_ATTR_TXN_ISOLATION,
            cast(SQLPOINTER)val, 0);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setTransactionIsolation");
    }

    // ── Generic attribute setters ─────────────────────────────────────────────

    /**
     * Sets a driver-specific integer connection attribute.
     *
     * Prefer the typed methods (setAutoCommit, setReadOnly, etc.) for standard
     * attributes.
     */
    void setAttribute(int attr, uint value) @trusted {
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, cast(SQLINTEGER)attr,
            cast(SQLPOINTER)cast(SQLULEN)value, 0);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setAttribute");
    }

    /**
     * Sets a driver-specific string connection attribute.
     */
    void setAttribute(int attr, string value) @trusted {
        auto valueZ = value.toStringz;
        SQLRETURN rc = SQLSetConnectAttr(_hdbc, cast(SQLINTEGER)attr,
            cast(SQLPOINTER)valueZ, cast(SQLINTEGER)value.length);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "setAttribute(string)");
    }

    // ── Statement factories ───────────────────────────────────────────────────

    /**
     * Creates a simple Statement for executing ad-hoc SQL queries.
     *
     * Returns: A new OdbcStatement.
     * Throws:  OdbcException on failure.
     */
    OdbcStatement createStatement() @trusted {
        SQLHSTMT hstmt;
        SQLRETURN rc = SQLAllocHandle(SQL_HANDLE_STMT, _hdbc, &hstmt);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "SQLAllocHandle(STMT)");
        return new OdbcStatement(hstmt);
    }

    /**
     * Prepares an SQL statement for repeated execution.
     *
     * Use '?' as a placeholder for each parameter.
     *
     * Params:
     *   sql = The SQL statement to prepare.
     * Returns: A new OdbcPreparedStatement.
     * Throws:  OdbcException on failure.
     */
    OdbcPreparedStatement prepareStatement(string sql) @trusted {
        SQLHSTMT hstmt;
        SQLRETURN rc = SQLAllocHandle(SQL_HANDLE_STMT, _hdbc, &hstmt);
        checkOdbc(rc, SQL_HANDLE_DBC, _hdbc, "SQLAllocHandle(STMT)");

        auto sqlZ = sql.toStringz;
        rc = SQLPrepare(hstmt, cast(SQLCHAR*)sqlZ, cast(SQLINTEGER)sql.length);
        if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO) {
            auto ex = OdbcException.fromHandle(SQL_HANDLE_STMT, hstmt, "SQLPrepare");
            SQLFreeHandle(SQL_HANDLE_STMT, hstmt);
            throw ex;
        }

        return new OdbcPreparedStatement(hstmt);
    }

    // ── Package-level handle access ───────────────────────────────────────────

    package SQLHDBC handle() pure nothrow @safe { return _hdbc; }

    // ── Private ───────────────────────────────────────────────────────────────

private:
    SQLHDBC _hdbc;
    bool    _connected;

    this(SQLHDBC hdbc) @safe {
        _hdbc      = hdbc;
        _connected = false;
    }
}
