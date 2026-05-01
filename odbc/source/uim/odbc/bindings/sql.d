/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.bindings.sql;

// ---------------------------------------------------------------------------
// ODBC C API bindings for D
// Covers ODBC 3.x (ISO CLI) – types, constants, structs, and functions.
// On Windows the ODBC driver manager exports via stdcall (extern(Windows)).
// On Linux/macOS unixODBC/iODBC exports via cdecl (extern(C)).
// ---------------------------------------------------------------------------

// ── Basic C types ────────────────────────────────────────────────────────────

alias SQLCHAR      = ubyte;
alias SQLSCHAR     = byte;
alias SQLWCHAR     = wchar;
alias SQLSMALLINT  = short;
alias SQLUSMALLINT = ushort;
alias SQLINTEGER   = int;
alias SQLUINTEGER  = uint;
alias SQLREAL      = float;
alias SQLDOUBLE    = double;
alias SQLFLOAT     = double;
alias SQLPOINTER   = void*;
alias SQLBIGINT    = long;
alias SQLUBIGINT   = ulong;

// ── Handle types ─────────────────────────────────────────────────────────────

alias SQLHANDLE = void*;
alias SQLHENV   = SQLHANDLE;
alias SQLHDBC   = SQLHANDLE;
alias SQLHSTMT  = SQLHANDLE;
alias SQLHDESC  = SQLHANDLE;
alias SQLHWND   = void*;
alias SQLRETURN = SQLSMALLINT;

// ── Platform-sized length/indicator types (ODBC 3.x) ─────────────────────────

static if (size_t.sizeof == 8) {
    alias SQLLEN        = long;
    alias SQLULEN       = ulong;
    alias SQLSETPOSIROW = ulong;
} else {
    alias SQLLEN        = int;
    alias SQLULEN       = uint;
    alias SQLSETPOSIROW = ushort;
}

// ── Return codes ─────────────────────────────────────────────────────────────

enum SQLRETURN SQL_SUCCESS           =  0;
enum SQLRETURN SQL_SUCCESS_WITH_INFO =  1;
enum SQLRETURN SQL_STILL_EXECUTING   =  2;
enum SQLRETURN SQL_ERROR             = -1;
enum SQLRETURN SQL_INVALID_HANDLE    = -2;
enum SQLRETURN SQL_NEED_DATA         = 99;
enum SQLRETURN SQL_NO_DATA           = 100;

// ── Handle type constants ─────────────────────────────────────────────────────

enum SQLSMALLINT SQL_HANDLE_ENV  = 1;
enum SQLSMALLINT SQL_HANDLE_DBC  = 2;
enum SQLSMALLINT SQL_HANDLE_STMT = 3;
enum SQLSMALLINT SQL_HANDLE_DESC = 4;

enum SQLHANDLE SQL_NULL_HANDLE = null;

// ── ODBC versions ─────────────────────────────────────────────────────────────

enum SQLINTEGER SQL_OV_ODBC2    = 2;
enum SQLINTEGER SQL_OV_ODBC3    = 3;
enum SQLINTEGER SQL_OV_ODBC3_80 = cast(SQLINTEGER)380;

// ── Environment attributes ────────────────────────────────────────────────────

enum SQLINTEGER SQL_ATTR_ODBC_VERSION       = 200;
enum SQLINTEGER SQL_ATTR_CONNECTION_POOLING = 201;
enum SQLINTEGER SQL_ATTR_CP_MATCH           = 202;
enum SQLINTEGER SQL_ATTR_OUTPUT_NTS         = 10001;

// ── Connection attributes ─────────────────────────────────────────────────────

enum SQLINTEGER SQL_ATTR_ACCESS_MODE        = 101;
enum SQLINTEGER SQL_ATTR_AUTOCOMMIT         = 102;
enum SQLINTEGER SQL_ATTR_LOGIN_TIMEOUT      = 103;
enum SQLINTEGER SQL_ATTR_TRACE              = 104;
enum SQLINTEGER SQL_ATTR_TRACEFILE          = 105;
enum SQLINTEGER SQL_ATTR_TRANSLATE_LIB      = 106;
enum SQLINTEGER SQL_ATTR_TRANSLATE_OPTION   = 107;
enum SQLINTEGER SQL_ATTR_TXN_ISOLATION      = 108;
enum SQLINTEGER SQL_ATTR_CURRENT_CATALOG    = 109;
enum SQLINTEGER SQL_ATTR_ODBC_CURSORS       = 110;
enum SQLINTEGER SQL_ATTR_QUIET_MODE         = 111;
enum SQLINTEGER SQL_ATTR_PACKET_SIZE        = 112;
enum SQLINTEGER SQL_ATTR_CONNECTION_TIMEOUT = 113;
enum SQLINTEGER SQL_ATTR_METADATA_ID        = 10014;

// AutoCommit values
enum SQLULEN SQL_AUTOCOMMIT_OFF = 0;
enum SQLULEN SQL_AUTOCOMMIT_ON  = 1;

// Access mode
enum SQLULEN SQL_MODE_READ_WRITE = 0;
enum SQLULEN SQL_MODE_READ_ONLY  = 1;

// Transaction isolation
enum SQLULEN SQL_TXN_READ_UNCOMMITTED = 1;
enum SQLULEN SQL_TXN_READ_COMMITTED   = 2;
enum SQLULEN SQL_TXN_REPEATABLE_READ  = 4;
enum SQLULEN SQL_TXN_SERIALIZABLE     = 8;

// ── Statement attributes ──────────────────────────────────────────────────────

enum SQLINTEGER SQL_ATTR_CURSOR_SCROLLABLE      = -1;
enum SQLINTEGER SQL_ATTR_CURSOR_SENSITIVITY     = -2;
enum SQLINTEGER SQL_ATTR_APP_ROW_DESC           = 10010;
enum SQLINTEGER SQL_ATTR_APP_PARAM_DESC         = 10011;
enum SQLINTEGER SQL_ATTR_IMP_ROW_DESC           = 10012;
enum SQLINTEGER SQL_ATTR_IMP_PARAM_DESC         = 10013;
enum SQLINTEGER SQL_ATTR_CURSOR_TYPE            = 6;
enum SQLINTEGER SQL_ATTR_CONCURRENCY            = 7;
enum SQLINTEGER SQL_ATTR_KEYSET_SIZE            = 8;
enum SQLINTEGER SQL_ATTR_MAX_ROWS               = 1;
enum SQLINTEGER SQL_ATTR_NOSCAN                 = 2;
enum SQLINTEGER SQL_ATTR_MAX_LENGTH             = 3;
enum SQLINTEGER SQL_ATTR_QUERY_TIMEOUT          = 0;
enum SQLINTEGER SQL_ATTR_RETRIEVE_DATA          = 11;
enum SQLINTEGER SQL_ATTR_ROW_NUMBER             = 14;
enum SQLINTEGER SQL_ATTR_SIMULATE_CURSOR        = 10;
enum SQLINTEGER SQL_ATTR_USE_BOOKMARKS          = 12;
enum SQLINTEGER SQL_ATTR_PARAMSET_SIZE          = 22;
enum SQLINTEGER SQL_ATTR_PARAM_STATUS_PTR       = 20;
enum SQLINTEGER SQL_ATTR_PARAMS_PROCESSED_PTR   = 21;
enum SQLINTEGER SQL_ATTR_ROW_ARRAY_SIZE         = 27;
enum SQLINTEGER SQL_ATTR_ROWS_FETCHED_PTR       = 26;

// ── Null / special indicator values ──────────────────────────────────────────

enum SQLLEN SQL_NULL_DATA     = -1;
enum SQLLEN SQL_DATA_AT_EXEC  = -2;
enum SQLLEN SQL_NO_TOTAL      = -4;
enum SQLLEN SQL_DEFAULT_PARAM = -5;
enum SQLLEN SQL_NTS           = -3;  // null-terminated string

// ── SQLEndTran completion types ───────────────────────────────────────────────

enum SQLSMALLINT SQL_COMMIT   = 0;
enum SQLSMALLINT SQL_ROLLBACK = 1;

// ── Column nullability ────────────────────────────────────────────────────────

enum SQLUSMALLINT SQL_NO_NULLS          = 0;
enum SQLUSMALLINT SQL_NULLABLE          = 1;
enum SQLUSMALLINT SQL_NULLABLE_UNKNOWN  = 2;

// ── Parameter input/output types ─────────────────────────────────────────────

enum SQLSMALLINT SQL_PARAM_INPUT        = 1;
enum SQLSMALLINT SQL_PARAM_INPUT_OUTPUT = 2;
enum SQLSMALLINT SQL_PARAM_OUTPUT       = 4;

// ── SQL data types ────────────────────────────────────────────────────────────

enum SQLSMALLINT SQL_UNKNOWN_TYPE  =   0;
enum SQLSMALLINT SQL_CHAR          =   1;
enum SQLSMALLINT SQL_NUMERIC       =   2;
enum SQLSMALLINT SQL_DECIMAL       =   3;
enum SQLSMALLINT SQL_INTEGER       =   4;
enum SQLSMALLINT SQL_SMALLINT      =   5;
enum SQLSMALLINT SQL_FLOAT         =   6;
enum SQLSMALLINT SQL_REAL          =   7;
enum SQLSMALLINT SQL_DOUBLE        =   8;
enum SQLSMALLINT SQL_DATETIME      =   9;
enum SQLSMALLINT SQL_DATE          =   9;
enum SQLSMALLINT SQL_INTERVAL      =  10;
enum SQLSMALLINT SQL_TIME          =  10;
enum SQLSMALLINT SQL_TIMESTAMP     =  11;
enum SQLSMALLINT SQL_VARCHAR       =  12;
enum SQLSMALLINT SQL_LONGVARCHAR   =  -1;
enum SQLSMALLINT SQL_BINARY        =  -2;
enum SQLSMALLINT SQL_VARBINARY     =  -3;
enum SQLSMALLINT SQL_LONGVARBINARY =  -4;
enum SQLSMALLINT SQL_BIGINT        =  -5;
enum SQLSMALLINT SQL_TINYINT       =  -6;
enum SQLSMALLINT SQL_BIT           =  -7;
enum SQLSMALLINT SQL_WCHAR         =  -8;
enum SQLSMALLINT SQL_WVARCHAR      =  -9;
enum SQLSMALLINT SQL_WLONGVARCHAR  = -10;
enum SQLSMALLINT SQL_GUID          = -11;

// Verbose date/time types (ODBC 3.x preferred)
enum SQLSMALLINT SQL_TYPE_DATE      = 91;
enum SQLSMALLINT SQL_TYPE_TIME      = 92;
enum SQLSMALLINT SQL_TYPE_TIMESTAMP = 93;

// ── SQL_C_* (C application types) ────────────────────────────────────────────

enum SQLSMALLINT SQL_C_CHAR           =   1;   // SQL_CHAR
enum SQLSMALLINT SQL_C_WCHAR          =  -8;   // SQL_WCHAR
enum SQLSMALLINT SQL_C_NUMERIC        =   2;   // SQL_NUMERIC
enum SQLSMALLINT SQL_C_BIT            =  -7;   // SQL_BIT
enum SQLSMALLINT SQL_C_TINYINT        =  -6;   // SQL_TINYINT
enum SQLSMALLINT SQL_C_STINYINT       = -26;
enum SQLSMALLINT SQL_C_UTINYINT       = -28;
enum SQLSMALLINT SQL_C_SHORT          =   5;   // SQL_SMALLINT
enum SQLSMALLINT SQL_C_SSHORT         =  -15;
enum SQLSMALLINT SQL_C_USHORT         =  -17;
enum SQLSMALLINT SQL_C_LONG           =   4;   // SQL_INTEGER
enum SQLSMALLINT SQL_C_SLONG          =  -16;
enum SQLSMALLINT SQL_C_ULONG          =  -18;
enum SQLSMALLINT SQL_C_FLOAT          =   7;   // SQL_REAL
enum SQLSMALLINT SQL_C_DOUBLE         =   8;   // SQL_DOUBLE
enum SQLSMALLINT SQL_C_SBIGINT        = -25;
enum SQLSMALLINT SQL_C_UBIGINT        = -27;
enum SQLSMALLINT SQL_C_BINARY         =  -2;   // SQL_BINARY
enum SQLSMALLINT SQL_C_DATE           =   9;
enum SQLSMALLINT SQL_C_TIME           =  10;
enum SQLSMALLINT SQL_C_TIMESTAMP      =  11;
enum SQLSMALLINT SQL_C_TYPE_DATE      =  91;
enum SQLSMALLINT SQL_C_TYPE_TIME      =  92;
enum SQLSMALLINT SQL_C_TYPE_TIMESTAMP =  93;
enum SQLSMALLINT SQL_C_DEFAULT        =  99;

// ── SQLDriverConnect driver-completion options ───────────────────────────────

enum SQLUSMALLINT SQL_DRIVER_NOPROMPT          = 0;
enum SQLUSMALLINT SQL_DRIVER_COMPLETE          = 1;
enum SQLUSMALLINT SQL_DRIVER_PROMPT            = 2;
enum SQLUSMALLINT SQL_DRIVER_COMPLETE_REQUIRED = 3;

// ── SQLDataSources / SQLDrivers fetch directions ─────────────────────────────

enum SQLUSMALLINT SQL_FETCH_NEXT  = 1;
enum SQLUSMALLINT SQL_FETCH_FIRST = 2;
enum SQLUSMALLINT SQL_FETCH_FIRST_USER   = 31;
enum SQLUSMALLINT SQL_FETCH_FIRST_SYSTEM = 32;

// ── SQL_MAX_NUMERIC_LEN ───────────────────────────────────────────────────────

enum SQL_MAX_NUMERIC_LEN = 16;

// ── ODBC structs ──────────────────────────────────────────────────────────────

extern(C) struct SQL_DATE_STRUCT {
    SQLSMALLINT  year;
    SQLUSMALLINT month;
    SQLUSMALLINT day;
}

extern(C) struct SQL_TIME_STRUCT {
    SQLUSMALLINT hour;
    SQLUSMALLINT minute;
    SQLUSMALLINT second;
}

extern(C) struct SQL_TIMESTAMP_STRUCT {
    SQLSMALLINT  year;
    SQLUSMALLINT month;
    SQLUSMALLINT day;
    SQLUSMALLINT hour;
    SQLUSMALLINT minute;
    SQLUSMALLINT second;
    SQLUINTEGER  fraction;  // nanoseconds (billionths of a second)
}

extern(C) struct SQL_NUMERIC_STRUCT {
    SQLCHAR  precision;
    SQLSCHAR scale;
    SQLCHAR  sign;  // 1 = positive, 0 = negative
    SQLCHAR[SQL_MAX_NUMERIC_LEN] val;
}

// ── Platform calling-convention ───────────────────────────────────────────────
//
// The ODBC driver manager on Windows uses __stdcall (WINAPI).
// On Linux/macOS the unixODBC/iODBC libraries use the standard C calling
// convention.  We expose all functions via a unified alias block below.

version(Windows) {
    extern(Windows):
} else {
    extern(C):
}

nothrow @nogc:

// ── Core handle management ────────────────────────────────────────────────────

SQLRETURN SQLAllocHandle(
    SQLSMALLINT  HandleType,
    SQLHANDLE    InputHandle,
    SQLHANDLE*   OutputHandlePtr);

SQLRETURN SQLFreeHandle(
    SQLSMALLINT HandleType,
    SQLHANDLE   Handle);

// ── Environment ───────────────────────────────────────────────────────────────

SQLRETURN SQLSetEnvAttr(
    SQLHENV     EnvironmentHandle,
    SQLINTEGER  Attribute,
    SQLPOINTER  ValuePtr,
    SQLINTEGER  StringLength);

SQLRETURN SQLGetEnvAttr(
    SQLHENV     EnvironmentHandle,
    SQLINTEGER  Attribute,
    SQLPOINTER  ValuePtr,
    SQLINTEGER  BufferLength,
    SQLINTEGER* StringLengthPtr);

SQLRETURN SQLDataSources(
    SQLHENV      EnvironmentHandle,
    SQLUSMALLINT Direction,
    SQLCHAR*     ServerName,
    SQLSMALLINT  BufferLength1,
    SQLSMALLINT* NameLength1Ptr,
    SQLCHAR*     Description,
    SQLSMALLINT  BufferLength2,
    SQLSMALLINT* NameLength2Ptr);

SQLRETURN SQLDrivers(
    SQLHENV      EnvironmentHandle,
    SQLUSMALLINT Direction,
    SQLCHAR*     DriverDescription,
    SQLSMALLINT  BufferLength1,
    SQLSMALLINT* DescriptionLengthPtr,
    SQLCHAR*     DriverAttributes,
    SQLSMALLINT  BufferLength2,
    SQLSMALLINT* AttributesLengthPtr);

// ── Connection ────────────────────────────────────────────────────────────────

SQLRETURN SQLConnect(
    SQLHDBC     ConnectionHandle,
    SQLCHAR*    ServerName,
    SQLSMALLINT NameLength1,
    SQLCHAR*    UserName,
    SQLSMALLINT NameLength2,
    SQLCHAR*    Authentication,
    SQLSMALLINT NameLength3);

SQLRETURN SQLDriverConnect(
    SQLHDBC      ConnectionHandle,
    SQLHWND      WindowHandle,
    SQLCHAR*     InConnectionString,
    SQLSMALLINT  StringLength1,
    SQLCHAR*     OutConnectionString,
    SQLSMALLINT  BufferLength,
    SQLSMALLINT* StringLength2Ptr,
    SQLUSMALLINT DriverCompletion);

SQLRETURN SQLDisconnect(SQLHDBC ConnectionHandle);

SQLRETURN SQLSetConnectAttr(
    SQLHDBC    ConnectionHandle,
    SQLINTEGER Attribute,
    SQLPOINTER ValuePtr,
    SQLINTEGER StringLength);

SQLRETURN SQLGetConnectAttr(
    SQLHDBC     ConnectionHandle,
    SQLINTEGER  Attribute,
    SQLPOINTER  ValuePtr,
    SQLINTEGER  BufferLength,
    SQLINTEGER* StringLengthPtr);

SQLRETURN SQLGetInfo(
    SQLHDBC      ConnectionHandle,
    SQLUSMALLINT InfoType,
    SQLPOINTER   InfoValuePtr,
    SQLSMALLINT  BufferLength,
    SQLSMALLINT* StringLengthPtr);

SQLRETURN SQLEndTran(
    SQLSMALLINT HandleType,
    SQLHANDLE   Handle,
    SQLSMALLINT CompletionType);

// ── Statement lifecycle ───────────────────────────────────────────────────────

SQLRETURN SQLPrepare(
    SQLHSTMT    StatementHandle,
    SQLCHAR*    StatementText,
    SQLINTEGER  TextLength);

SQLRETURN SQLExecute(SQLHSTMT StatementHandle);

SQLRETURN SQLExecDirect(
    SQLHSTMT   StatementHandle,
    SQLCHAR*   StatementText,
    SQLINTEGER TextLength);

SQLRETURN SQLFreeStmt(
    SQLHSTMT     StatementHandle,
    SQLUSMALLINT Option);

SQLRETURN SQLCloseCursor(SQLHSTMT StatementHandle);

SQLRETURN SQLCancel(SQLHSTMT StatementHandle);

SQLRETURN SQLSetStmtAttr(
    SQLHSTMT   StatementHandle,
    SQLINTEGER Attribute,
    SQLPOINTER ValuePtr,
    SQLINTEGER StringLength);

SQLRETURN SQLGetStmtAttr(
    SQLHSTMT    StatementHandle,
    SQLINTEGER  Attribute,
    SQLPOINTER  ValuePtr,
    SQLINTEGER  BufferLength,
    SQLINTEGER* StringLengthPtr);

// ── Parameters ────────────────────────────────────────────────────────────────

SQLRETURN SQLBindParameter(
    SQLHSTMT     StatementHandle,
    SQLUSMALLINT ParameterNumber,
    SQLSMALLINT  InputOutputType,
    SQLSMALLINT  ValueType,
    SQLSMALLINT  ParameterType,
    SQLULEN      ColumnSize,
    SQLSMALLINT  DecimalDigits,
    SQLPOINTER   ParameterValuePtr,
    SQLLEN       BufferLength,
    SQLLEN*      StrLen_or_IndPtr);

SQLRETURN SQLNumParams(
    SQLHSTMT     StatementHandle,
    SQLSMALLINT* ParameterCountPtr);

SQLRETURN SQLDescribeParam(
    SQLHSTMT      StatementHandle,
    SQLUSMALLINT  ParameterNumber,
    SQLSMALLINT*  DataTypePtr,
    SQLULEN*      ParameterSizePtr,
    SQLSMALLINT*  DecimalDigitsPtr,
    SQLSMALLINT*  NullablePtr);

// ── Result set – fetch ────────────────────────────────────────────────────────

SQLRETURN SQLFetch(SQLHSTMT StatementHandle);

SQLRETURN SQLFetchScroll(
    SQLHSTMT    StatementHandle,
    SQLSMALLINT FetchOrientation,
    SQLLEN      FetchOffset);

SQLRETURN SQLGetData(
    SQLHSTMT     StatementHandle,
    SQLUSMALLINT ColumnNumber,
    SQLSMALLINT  TargetType,
    SQLPOINTER   TargetValuePtr,
    SQLLEN       BufferLength,
    SQLLEN*      StrLen_or_IndPtr);

SQLRETURN SQLBindCol(
    SQLHSTMT     StatementHandle,
    SQLUSMALLINT ColumnNumber,
    SQLSMALLINT  TargetType,
    SQLPOINTER   TargetValuePtr,
    SQLLEN       BufferLength,
    SQLLEN*      StrLen_or_IndPtr);

SQLRETURN SQLRowCount(
    SQLHSTMT  StatementHandle,
    SQLLEN*   RowCountPtr);

// ── Result set – metadata ─────────────────────────────────────────────────────

SQLRETURN SQLNumResultCols(
    SQLHSTMT     StatementHandle,
    SQLSMALLINT* ColumnCountPtr);

SQLRETURN SQLDescribeCol(
    SQLHSTMT      StatementHandle,
    SQLUSMALLINT  ColumnNumber,
    SQLCHAR*      ColumnName,
    SQLSMALLINT   BufferLength,
    SQLSMALLINT*  NameLengthPtr,
    SQLSMALLINT*  DataTypePtr,
    SQLULEN*      ColumnSizePtr,
    SQLSMALLINT*  DecimalDigitsPtr,
    SQLSMALLINT*  NullablePtr);

SQLRETURN SQLColAttribute(
    SQLHSTMT      StatementHandle,
    SQLUSMALLINT  ColumnNumber,
    SQLUSMALLINT  FieldIdentifier,
    SQLPOINTER    CharacterAttributePtr,
    SQLSMALLINT   BufferLength,
    SQLSMALLINT*  StringLengthPtr,
    SQLLEN*       NumericAttributePtr);

// ── Diagnostics ───────────────────────────────────────────────────────────────

SQLRETURN SQLGetDiagRec(
    SQLSMALLINT  HandleType,
    SQLHANDLE    Handle,
    SQLSMALLINT  RecNumber,
    SQLCHAR*     SQLState,
    SQLINTEGER*  NativeErrorPtr,
    SQLCHAR*     MessageText,
    SQLSMALLINT  BufferLength,
    SQLSMALLINT* TextLengthPtr);

SQLRETURN SQLGetDiagField(
    SQLSMALLINT  HandleType,
    SQLHANDLE    Handle,
    SQLSMALLINT  RecNumber,
    SQLSMALLINT  DiagIdentifier,
    SQLPOINTER   DiagInfoPtr,
    SQLSMALLINT  BufferLength,
    SQLSMALLINT* StringLengthPtr);

// ── SQLFreeStmt options ───────────────────────────────────────────────────────

enum SQLUSMALLINT SQL_CLOSE        = 0;
enum SQLUSMALLINT SQL_DROP         = 1;
enum SQLUSMALLINT SQL_UNBIND       = 2;
enum SQLUSMALLINT SQL_RESET_PARAMS = 3;
