/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.interfaces.statement;

import uim.sql;

@safe:

/**
 * Interface for prepared statements
 */
interface IStatement {
    /**
     * Bind a parameter by index (1-based)
     */
    void bind(size_t index, SqlValue value) @trusted;

    /**
     * Bind a parameter by name
     */
    void bind(string name, SqlValue value) @trusted;

    /**
     * Bind multiple parameters
     */
    void bindAll(SqlValue[] values) @trusted;

    /**
     * Execute the statement
     */
    IResultSet execute() @trusted;

    /**
     * Execute as command (non-query)
     */
    QueryResult executeCommand() @trusted;

    /**
     * Reset bindings
     */
    void reset();

    /**
     * Get SQL text
     */
    string sql() const;

    /**
     * Close statement
     */
    void close();
}
