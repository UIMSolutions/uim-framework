/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.interfaces.connection;

import uim.sql;

@safe:

/**
 * Interface for database connections
 */
interface IConnection {
    /**
     * Establish connection to database
     */
    bool connect();

    /**
     * Close database connection
     */
    void close();

    /**
     * Check if connected
     */
    bool isConnected() const;

    /**
     * Execute a SQL query
     */
    IResultSet query(string sql, SqlValue[] params = null) @trusted;

    /**
     * Execute a SQL command (INSERT, UPDATE, DELETE)
     */
    QueryResult execute(string sql, SqlValue[] params = null) @trusted;

    /**
     * Execute a query builder
     */
    IResultSet execute(IQueryBuilder builder) @trusted;

    /**
     * Prepare a statement
     */
    IStatement prepare(string sql) @trusted;

    /**
     * Begin a transaction
     */
    ITransaction beginTransaction() @trusted;

    /**
     * Get last error message
     */
    string lastError() const;

    /**
     * Get connection configuration
     */
    ConnectionConfig config() const;

    /**
     * Set connection configuration
     */
    void config(ConnectionConfig newConfig);

    /**
     * Escape a string value for SQL
     */
    string escape(string value) const @trusted;

    /**
     * Quote identifier (table/column name)
     */
    string quoteIdentifier(string identifier) const;
}
