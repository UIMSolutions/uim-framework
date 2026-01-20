/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.interfaces.resultset;

import uim.sql;

@safe:

/**
 * Interface for query result sets
 */
interface IResultSet {
    /**
     * Get next row
     */
    bool next();

    /**
     * Get current row
     */
    SqlRow currentRow() const;

    /**
     * Get value from current row by column name
     */
    SqlValue get(string columnName) const;

    /**
     * Get value from current row by column index
     */
    SqlValue get(size_t columnIndex) const;

    /**
     * Get all rows
     */
    SqlRow[] all() @trusted;

    /**
     * Get first row
     */
    SqlRow first() @trusted;

    /**
     * Get column names
     */
    string[] columns() const;

    /**
     * Get row count
     */
    size_t rowCount() const;

    /**
     * Check if result set is empty
     */
    bool isEmpty() const;

    /**
     * Reset to beginning
     */
    void reset();

    /**
     * Close result set
     */
    void close();

    /**
     * Range interface for foreach
     */
    @property bool empty() const;
    @property SqlRow front() const;
    void popFront();
}
