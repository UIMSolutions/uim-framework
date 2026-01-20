/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.interfaces.dialect;

import uim.sql;

@safe:

/**
 * Interface for SQL dialect abstraction
 */
interface IDialect {
    /**
     * Get dialect type
     */
    SqlDialect dialectType() const;

    /**
     * Quote identifier (table/column name)
     */
    string quoteIdentifier(string identifier) const;

    /**
     * Format limit clause
     */
    string formatLimit(size_t limit, size_t offset) const;

    /**
     * Format boolean value
     */
    string formatBoolean(bool value) const;

    /**
     * Format datetime value
     */
    string formatDateTime(string value) const;

    /**
     * Get current timestamp expression
     */
    string currentTimestamp() const;

    /**
     * Get auto increment syntax
     */
    string autoIncrement() const;

    /**
     * Support for returning clause
     */
    bool supportsReturning() const;

    /**
     * Support for CTEs (WITH clause)
     */
    bool supportsCTE() const;

    /**
     * Support for window functions
     */
    bool supportsWindowFunctions() const;
}
