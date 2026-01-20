/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.classes.dialect;

import uim.sql;
import std.conv : to;

@safe:

/**
 * Generic SQL dialect implementation
 */
class GenericDialect : UIMObject, IDialect {
    mixin(ObjThis!("GenericDialect"));

    SqlDialect dialectType() const {
        return SqlDialect.GENERIC;
    }

    string quoteIdentifier(string identifier) const {
        return "\"" ~ identifier ~ "\"";
    }

    string formatLimit(size_t limit, size_t offset) const {
        string result = "LIMIT " ~ limit.to!string;
        if (offset > 0) {
            result ~= " OFFSET " ~ offset.to!string;
        }
        return result;
    }

    string formatBoolean(bool value) const {
        return value ? "TRUE" : "FALSE";
    }

    string formatDateTime(string value) const {
        return "'" ~ value ~ "'";
    }

    string currentTimestamp() const {
        return "CURRENT_TIMESTAMP";
    }

    string autoIncrement() const {
        return "AUTO_INCREMENT";
    }

    bool supportsReturning() const {
        return false;
    }

    bool supportsCTE() const {
        return true;
    }

    bool supportsWindowFunctions() const {
        return true;
    }
}

/**
 * MySQL dialect
 */
class MySQLDialect : GenericDialect {
    mixin(ObjThis!("MySQLDialect"));

    override SqlDialect dialectType() const {
        return SqlDialect.MYSQL;
    }

    override string quoteIdentifier(string identifier) const {
        return "`" ~ identifier ~ "`";
    }

    override string formatBoolean(bool value) const {
        return value ? "1" : "0";
    }

    override bool supportsReturning() const {
        return false;
    }
}

/**
 * PostgreSQL dialect
 */
class PostgreSQLDialect : GenericDialect {
    mixin(ObjThis!("PostgreSQLDialect"));

    override SqlDialect dialectType() const {
        return SqlDialect.POSTGRESQL;
    }

    override string autoIncrement() const {
        return "SERIAL";
    }

    override bool supportsReturning() const {
        return true;
    }
}

/**
 * SQLite dialect
 */
class SQLiteDialect : GenericDialect {
    mixin(ObjThis!("SQLiteDialect"));

    override SqlDialect dialectType() const {
        return SqlDialect.SQLITE;
    }

    override string autoIncrement() const {
        return "AUTOINCREMENT";
    }

    override bool supportsReturning() const {
        return true; // SQLite 3.35+
    }

    override bool supportsCTE() const {
        return true;
    }
}
