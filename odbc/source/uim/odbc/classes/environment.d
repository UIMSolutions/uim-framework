/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.environment;

import uim.odbc.bindings.sql;
import uim.odbc.classes.exception;
import uim.odbc.classes.connection;
import uim.odbc.enumerations.types;

// ---------------------------------------------------------------------------
// OdbcEnvironment – wraps an ODBC SQLHENV handle.
// ---------------------------------------------------------------------------

/**
 * Stores the name and description of an ODBC data source.
 */
struct DataSourceInfo {
    /// The data source name, e.g. "SQL Server" or "dBASE Files".
    string name;
    /// Description of the associated driver.
    string description;
}

/**
 * Stores the description and key=value attribute pairs of an ODBC driver.
 */
struct DriverInfo {
    /// Attribute key/value pair.
    struct Attribute {
        string name;
        string value;
    }
    /// Driver description.
    string description;
    /// Driver attributes (e.g. "DriverODBCVer=03.51").
    Attribute[] attributes;
}

// ---------------------------------------------------------------------------

/**
 * ODBC environment context.
 *
 * The environment must be created before any connections can be made.
 * It configures the ODBC version and acts as a factory for OdbcConnection
 * objects.
 *
 * Example:
 * ---
 * auto env  = OdbcEnvironment.create();
 * auto conn = env.createConnection();
 * conn.connect("myDSN", "user", "pass");
 * ---
 */
class OdbcEnvironment {

    // ── Factory ───────────────────────────────────────────────────────────────

    /**
     * Allocates a new ODBC environment handle and sets the ODBC version to 3.x.
     *
     * Returns: A new OdbcEnvironment instance.
     * Throws:  OdbcException on failure.
     */
    static OdbcEnvironment create() @trusted {
        SQLHENV henv;
        SQLRETURN rc = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &henv);
        if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
            throw new OdbcException("SQLAllocHandle(ENV) failed");

        // Request ODBC 3.x behaviour
        rc = SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION,
                           cast(SQLPOINTER)SQL_OV_ODBC3, 0);
        if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO) {
            SQLFreeHandle(SQL_HANDLE_ENV, henv);
            throw OdbcException.fromHandle(SQL_HANDLE_ENV, henv,
                                           "SQLSetEnvAttr(ODBC_VERSION)");
        }

        return new OdbcEnvironment(henv);
    }

    // ── Destructor ────────────────────────────────────────────────────────────

    ~this() @trusted {
        if (_henv !is null) {
            SQLFreeHandle(SQL_HANDLE_ENV, _henv);
            _henv = null;
        }
    }

    // ── Connection factory ────────────────────────────────────────────────────

    /**
     * Allocates and returns a new OdbcConnection object that belongs to this
     * environment.  The connection is not yet connected to any database.
     *
     * Returns: A new, disconnected OdbcConnection.
     * Throws:  OdbcException on failure.
     */
    OdbcConnection createConnection() @trusted {
        SQLHDBC hdbc;
        SQLRETURN rc = SQLAllocHandle(SQL_HANDLE_DBC, _henv, &hdbc);
        checkOdbc(rc, SQL_HANDLE_ENV, _henv, "SQLAllocHandle(DBC)");
        return new OdbcConnection(hdbc);
    }

    // ── Data source enumeration ───────────────────────────────────────────────

    /**
     * Returns information about all available ODBC data sources.
     *
     * Params:
     *   dsnType = Filter for user/system/all DSNs (default ALL).
     * Returns: Array of DataSourceInfo structs.
     * Throws:  OdbcException on failure.
     */
    DataSourceInfo[] getDataSources(DSNType dsnType = DSNType.ALL) @trusted {
        DataSourceInfo[] result;

        SQLUSMALLINT direction;
        final switch (dsnType) {
            case DSNType.ALL:    direction = SQL_FETCH_FIRST;        break;
            case DSNType.USER:   direction = SQL_FETCH_FIRST_USER;   break;
            case DSNType.SYSTEM: direction = SQL_FETCH_FIRST_SYSTEM; break;
        }

        SQLCHAR[256] name;
        SQLCHAR[256] desc;
        SQLSMALLINT  nameLen, descLen;

        while (true) {
            SQLRETURN rc = SQLDataSources(_henv, direction,
                name.ptr, cast(SQLSMALLINT)name.sizeof, &nameLen,
                desc.ptr, cast(SQLSMALLINT)desc.sizeof, &descLen);

            if (rc == SQL_NO_DATA) break;
            checkOdbc(rc, SQL_HANDLE_ENV, _henv, "SQLDataSources");

            result ~= DataSourceInfo(
                cast(string)name[0 .. nameLen].idup,
                cast(string)desc[0 .. descLen].idup);

            direction = SQL_FETCH_NEXT;
        }

        return result;
    }

    /**
     * Returns information about all installed ODBC drivers.
     *
     * Returns: Array of DriverInfo structs.
     * Throws:  OdbcException on failure.
     */
    DriverInfo[] getDrivers() @trusted {
        import std.string : split;

        DriverInfo[] result;

        SQLCHAR[512] desc;
        SQLCHAR[512] attrs;
        SQLSMALLINT  descLen, attrsLen;
        SQLUSMALLINT direction = SQL_FETCH_FIRST;

        while (true) {
            SQLRETURN rc = SQLDrivers(_henv, direction,
                desc.ptr,  cast(SQLSMALLINT)desc.sizeof,  &descLen,
                attrs.ptr, cast(SQLSMALLINT)attrs.sizeof, &attrsLen);

            if (rc == SQL_NO_DATA) break;
            checkOdbc(rc, SQL_HANDLE_ENV, _henv, "SQLDrivers");

            DriverInfo di;
            di.description = cast(string)desc[0 .. descLen].idup;

            // Attributes are a double-null-terminated list of "key=value" pairs
            size_t i = 0;
            size_t end = attrsLen > 0 ? cast(size_t)attrsLen : 0;
            while (i < end) {
                size_t j = i;
                while (j < end && attrs[j] != 0) j++;
                if (j > i) {
                    string kv = cast(string)attrs[i .. j].idup;
                    auto eq = kv.indexOf('=');
                    if (eq >= 0) {
                        di.attributes ~= DriverInfo.Attribute(kv[0 .. eq], kv[eq + 1 .. $]);
                    } else {
                        di.attributes ~= DriverInfo.Attribute(kv, "");
                    }
                }
                i = j + 1;
            }

            result ~= di;
            direction = SQL_FETCH_NEXT;
        }

        return result;
    }

    /**
     * Checks whether the named driver is installed.
     *
     * Params:
     *   name = Driver name (case-insensitive on most platforms).
     * Returns: true if found, false otherwise.
     */
    bool isDriverInstalled(string name) @trusted {
        import std.algorithm : canFind;
        import std.uni       : toLower;
        string needle = name.toLower;
        foreach (d; getDrivers()) {
            if (d.description.toLower == needle) return true;
        }
        return false;
    }

    // ── Private ───────────────────────────────────────────────────────────────

private:
    SQLHENV _henv;

    this(SQLHENV henv) @safe { _henv = henv; }
}

// ---------------------------------------------------------------------------
// Helper used by DriverInfo parsing
// ---------------------------------------------------------------------------

private ptrdiff_t indexOf(string s, char c) pure nothrow @safe {
    foreach (i, ch; s) {
        if (ch == c) return cast(ptrdiff_t)i;
    }
    return -1;
}
