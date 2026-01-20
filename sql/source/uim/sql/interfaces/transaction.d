/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.interfaces.transaction;

import uim.sql;

@safe:

/**
 * Interface for database transactions
 */
interface ITransaction {
    /**
     * Commit the transaction
     */
    bool commit() @trusted;

    /**
     * Rollback the transaction
     */
    bool rollback() @trusted;

    /**
     * Check if transaction is active
     */
    bool isActive() const;

    /**
     * Get isolation level
     */
    IsolationLevel isolationLevel() const;

    /**
     * Set isolation level
     */
    void isolationLevel(IsolationLevel level);

    /**
     * Create a savepoint
     */
    bool savepoint(string name) @trusted;

    /**
     * Rollback to savepoint
     */
    bool rollbackTo(string name) @trusted;

    /**
     * Release savepoint
     */
    bool releaseSavepoint(string name) @trusted;
}
