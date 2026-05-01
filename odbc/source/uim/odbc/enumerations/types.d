/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.enumerations.types;

// ---------------------------------------------------------------------------
// D enumerations that mirror the ODBC 3.x type system.
// ---------------------------------------------------------------------------

/**
 * Specifies the type of DSN to retrieve via Environment.getDataSources().
 */
enum DSNType {
    /// Both user and system DSNs are returned.
    ALL,
    /// Only system DSNs are returned.
    SYSTEM,
    /// Only user DSNs are returned.
    USER
}

/**
 * Transaction isolation levels, ordered from least to most strict.
 */
enum TransactionIsolationLevel {
    /// Dirty reads, non-repeatable reads and phantoms are possible.
    READ_UNCOMMITTED,
    /// Prevents dirty reads; non-repeatable reads and phantoms are possible.
    READ_COMMITTED,
    /// Prevents dirty and non-repeatable reads; phantoms are possible.
    REPEATABLE_READ,
    /// Prevents all anomalies (dirty / non-repeatable / phantom reads).
    SERIALIZABLE,
    /// The database does not support transactions.
    NONE
}

/**
 * ODBC SQL data type constants.
 *
 * Mirrors the SQL_* constants from the ODBC C header but exposed as a D enum
 * so callers can use them without importing the raw bindings module.
 */
enum SQLDataType : short {
    UNKNOWN_TYPE  =   0,
    CHAR          =   1,
    NUMERIC       =   2,
    DECIMAL       =   3,
    INTEGER       =   4,
    SMALLINT      =   5,
    FLOAT         =   6,
    REAL          =   7,
    DOUBLE        =   8,
    DATETIME      =   9,
    DATE          =   9,
    INTERVAL      =  10,
    TIME          =  10,
    TIMESTAMP     =  11,
    VARCHAR       =  12,
    LONGVARCHAR   =  -1,
    BINARY        =  -2,
    VARBINARY     =  -3,
    LONGVARBINARY =  -4,
    BIGINT        =  -5,
    TINYINT       =  -6,
    BIT           =  -7,
    WCHAR         =  -8,
    WVARCHAR      =  -9,
    WLONGVARCHAR  = -10,
    GUID          = -11,
    TYPE_DATE     =  91,
    TYPE_TIME     =  92,
    TYPE_TIMESTAMP=  93,
}

/**
 * Nullability status of a result-set column.
 */
enum ColumnNullable {
    /// Column does not allow NULL values.
    NO_NULLS,
    /// Column allows NULL values.
    NULLABLE,
    /// Nullability is unknown.
    UNKNOWN
}

/**
 * Type of unique row identifier returned by DatabaseMetaData.getSpecialColumns.
 */
enum RowIdentifierType {
    /// Returns the optimal column(s) for unique row identification.
    BEST_ROWID,
    /// Returns columns automatically updated by the data source.
    ROWVER
}

/**
 * Scope of a row identifier.
 */
enum RowIdentifierScope {
    /// Valid only while cursor is positioned on the row.
    CURRENT_ROW,
    /// Valid for the duration of the session.
    SESSION,
    /// Valid for the duration of the current transaction.
    TRANSACTION
}

/**
 * Index type filter for DatabaseMetaData.getIndexInfo.
 */
enum IndexType {
    /// All indexes are returned.
    ALL,
    /// Only unique indexes are returned.
    UNIQUE
}

/**
 * Statistics accuracy for DatabaseMetaData.getTableStatistics.
 */
enum StatisticsAccuracy {
    /// Driver retrieves statistics unconditionally.
    ENSURE,
    /// Driver returns CARDINALITY/PAGES only when readily available.
    QUICK
}
