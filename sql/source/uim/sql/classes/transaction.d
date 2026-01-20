/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.classes.transaction;

import uim.sql;

@safe:

/**
 * Implementation of transaction
 */
class Transaction : UIMObject, ITransaction {
    mixin(ObjThis!("Transaction"));

    protected IConnection _connection;
    protected bool _active;
    protected IsolationLevel _isolationLevel;
    protected string[] _savepoints;

    this(IConnection connection) {
        super();
        _connection = connection;
        _active = true;
        _isolationLevel = IsolationLevel.READ_COMMITTED;
    }

    bool commit() @trusted {
        if (!_active) {
            return false;
        }

        auto result = _connection.execute("COMMIT");
        _active = false;
        return result.success;
    }

    bool rollback() @trusted {
        if (!_active) {
            return false;
        }

        auto result = _connection.execute("ROLLBACK");
        _active = false;
        return result.success;
    }

    bool isActive() const {
        return _active;
    }

    IsolationLevel isolationLevel() const {
        return _isolationLevel;
    }

    void isolationLevel(IsolationLevel level) {
        _isolationLevel = level;
        
        // Apply isolation level
        string levelStr;
        final switch (level) {
            case IsolationLevel.READ_UNCOMMITTED:
                levelStr = "READ UNCOMMITTED";
                break;
            case IsolationLevel.READ_COMMITTED:
                levelStr = "READ COMMITTED";
                break;
            case IsolationLevel.REPEATABLE_READ:
                levelStr = "REPEATABLE READ";
                break;
            case IsolationLevel.SERIALIZABLE:
                levelStr = "SERIALIZABLE";
                break;
        }
        
        _connection.execute("SET TRANSACTION ISOLATION LEVEL " ~ levelStr);
    }

    bool savepoint(string name) @trusted {
        if (!_active) {
            return false;
        }

        auto result = _connection.execute("SAVEPOINT " ~ name);
        if (result.success) {
            _savepoints ~= name;
        }
        return result.success;
    }

    bool rollbackTo(string name) @trusted {
        if (!_active) {
            return false;
        }

        auto result = _connection.execute("ROLLBACK TO SAVEPOINT " ~ name);
        return result.success;
    }

    bool releaseSavepoint(string name) @trusted {
        if (!_active) {
            return false;
        }

        auto result = _connection.execute("RELEASE SAVEPOINT " ~ name);
        if (result.success) {
            import std.algorithm : remove;
            import std.range : assumeSorted;
            // Remove savepoint from list
            foreach (i, sp; _savepoints) {
                if (sp == name) {
                    _savepoints = _savepoints.remove(i);
                    break;
                }
            }
        }
        return result.success;
    }
}
