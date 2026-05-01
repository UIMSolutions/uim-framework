/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.classes.exception;

import uim.odbc.bindings.sql;
import std.string : fromStringz;
import std.conv   : to;

// ---------------------------------------------------------------------------
// OdbcException – wraps ODBC diagnostic records as a D exception.
// ---------------------------------------------------------------------------

/**
 * Thrown whenever an ODBC function returns SQL_ERROR or SQL_INVALID_HANDLE.
 *
 * The exception collects all diagnostic records for the failing handle and
 * concatenates their messages into one human-readable string.
 */
class OdbcException : Exception {

    // ── Public state ─────────────────────────────────────────────────────────

    /**
     * The 5-character SQLSTATE of the first diagnostic record, e.g. "42000".
     * Empty if the SQLSTATE could not be determined.
     */
    string sqlState;

    /**
     * The native (driver-specific) error code from the first diagnostic record.
     */
    int nativeError;

    // ── Factory ───────────────────────────────────────────────────────────────

    /**
     * Reads all diagnostic records from `handle` and throws (or returns)
     * an OdbcException that aggregates their messages.
     *
     * Params:
     *   handleType = SQL_HANDLE_ENV, SQL_HANDLE_DBC, or SQL_HANDLE_STMT.
     *   handle     = The ODBC handle whose diagnostics should be read.
     *   operation  = Human-readable description of the failing operation
     *                (prepended to the error message for context).
     */
    static OdbcException fromHandle(
        SQLSMALLINT handleType,
        SQLHANDLE   handle,
        string      operation = "") @trusted
    {
        import std.array : appender;

        auto sb       = appender!string;
        bool firstRec = true;

        string    firstState;
        SQLINTEGER firstNative;

        SQLCHAR[6]   state;
        SQLINTEGER   nativeErr;
        SQLCHAR[512] msg;
        SQLSMALLINT  msgLen;
        SQLSMALLINT  recNo = 1;

        while (true) {
            SQLRETURN rc = SQLGetDiagRec(
                handleType, handle, recNo,
                state.ptr, &nativeErr,
                msg.ptr, cast(SQLSMALLINT)msg.sizeof, &msgLen);

            if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
                break;

            size_t validLen = (msgLen >= 0 && msgLen < cast(SQLSMALLINT)msg.sizeof)
                              ? cast(size_t)msgLen
                              : msg.sizeof - 1;
            string msgStr  = cast(string)msg[0 .. validLen].idup;
            string stateStr = cast(string)state[0 .. 5].idup;

            if (firstRec) {
                firstState  = stateStr;
                firstNative = nativeErr;
                firstRec    = false;
                if (operation.length > 0)
                    sb.put(operation ~ ": ");
            } else {
                sb.put("; ");
            }

            sb.put("[");
            sb.put(stateStr);
            sb.put("] ");
            sb.put(msgStr);
            recNo++;
        }

        string fullMsg = sb.data.length > 0
                         ? sb.data
                         : (operation.length > 0
                            ? operation ~ ": ODBC error (no diagnostic info)"
                            : "ODBC error (no diagnostic info)");

        auto ex          = new OdbcException(fullMsg);
        ex.sqlState      = firstState;
        ex.nativeError   = cast(int)firstNative;
        return ex;
    }

    // ── Constructor ───────────────────────────────────────────────────────────

    this(string msg, string file = __FILE__, size_t line = __LINE__) pure @safe {
        super(msg, file, line);
    }
}

// ---------------------------------------------------------------------------
// Internal helper – called after every ODBC API function.
// ---------------------------------------------------------------------------

/**
 * Checks the SQLRETURN value and throws OdbcException on error.
 *
 * SQL_SUCCESS and SQL_SUCCESS_WITH_INFO are both treated as success.
 * SQL_NO_DATA is treated as success (caller must handle it separately).
 *
 * Params:
 *   ret        = Return value from the ODBC function.
 *   handleType = Type of the ODBC handle (SQL_HANDLE_ENV/DBC/STMT).
 *   handle     = The ODBC handle for extracting diagnostics.
 *   op         = Name of the ODBC operation (for error messages).
 */
package void checkOdbc(
    SQLRETURN   ret,
    SQLSMALLINT handleType,
    SQLHANDLE   handle,
    string      op = "") @trusted
{
    if (ret == SQL_SUCCESS || ret == SQL_SUCCESS_WITH_INFO || ret == SQL_NO_DATA)
        return;

    throw OdbcException.fromHandle(handleType, handle, op);
}
