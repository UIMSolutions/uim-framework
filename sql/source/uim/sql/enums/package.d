/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.enums;

/**
 * SQL data types
 */
enum SqlType {
    INTEGER,
    BIGINT,
    SMALLINT,
    DECIMAL,
    NUMERIC,
    FLOAT,
    DOUBLE,
    REAL,
    VARCHAR,
    CHAR,
    TEXT,
    BLOB,
    BOOLEAN,
    DATE,
    TIME,
    DATETIME,
    TIMESTAMP,
    JSON,
    UUID,
    NULL
}

/**
 * SQL dialect types
 */
enum SqlDialect {
    GENERIC,
    MYSQL,
    POSTGRESQL,
    SQLITE,
    MSSQL,
    ORACLE
}

/**
 * Transaction isolation levels
 */
enum IsolationLevel {
    READ_UNCOMMITTED,
    READ_COMMITTED,
    REPEATABLE_READ,
    SERIALIZABLE
}

/**
 * Join types
 */
enum JoinType {
    INNER,
    LEFT,
    RIGHT,
    FULL,
    CROSS
}

/**
 * Sort order
 */
enum SortOrder {
    ASC,
    DESC
}

/**
 * Query type
 */
enum QueryType {
    SELECT,
    INSERT,
    UPDATE,
    DELETE,
    CREATE,
    ALTER,
    DROP,
    TRUNCATE
}

/**
 * Comparison operators
 */
enum ComparisonOp {
    EQUAL,
    NOT_EQUAL,
    LESS_THAN,
    LESS_EQUAL,
    GREATER_THAN,
    GREATER_EQUAL,
    LIKE,
    NOT_LIKE,
    IN,
    NOT_IN,
    IS_NULL,
    IS_NOT_NULL,
    BETWEEN
}
