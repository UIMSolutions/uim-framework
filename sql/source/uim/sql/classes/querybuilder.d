/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.classes.querybuilder;

import uim.sql;
import std.array : join;
import std.conv : to;

/**
 * Implementation of fluent query builder
 */
class QueryBuilder : UIMObject, IQueryBuilder {
    mixin(ObjThis!("QueryBuilder"));

    protected QueryType _queryType;
    protected string[] _selectColumns;
    protected string _tableName;
    protected string[] _whereClauses;
    protected string[] _joinClauses;
    protected string[] _groupByColumns;
    protected string _havingClause;
    protected string[] _orderByClauses;
    protected size_t _limitValue;
    protected size_t _offsetValue;
    protected SqlValue[string] _insertValues;
    protected SqlValue[string] _updateValues;
    protected SqlValue[] _parameters;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        reset();
        return true;
    }

    IQueryBuilder select(string[] columns...) {
        _queryType = QueryType.SELECT;
        _selectColumns = columns.dup;
        return this;
    }

    IQueryBuilder from(string table) {
        _tableName = table;
        return this;
    }

    IQueryBuilder where(string column, string op, SqlValue value) {
        string clause = column ~ " " ~ op ~ " ?";
        if (_whereClauses.length == 0) {
            _whereClauses ~= "WHERE " ~ clause;
        } else {
            _whereClauses ~= "AND " ~ clause;
        }
        _parameters ~= value;
        return this;
    }

    IQueryBuilder whereRaw(string condition, SqlValue[] params = null) {
        if (_whereClauses.length == 0) {
            _whereClauses ~= "WHERE " ~ condition;
        } else {
            _whereClauses ~= "AND " ~ condition;
        }
        if (params !is null) {
            _parameters ~= params;
        }
        return this;
    }

    IQueryBuilder andWhere(string column, string op, SqlValue value) {
        return where(column, op, value);
    }

    IQueryBuilder orWhere(string column, string op, SqlValue value) {
        string clause = column ~ " " ~ op ~ " ?";
        _whereClauses ~= "OR " ~ clause;
        _parameters ~= value;
        return this;
    }

    IQueryBuilder whereIn(string column, SqlValue[] values) {
        import std.algorithm : map;
        import std.range : repeat;
        
        auto placeholders = "?".repeat(values.length).join(", ");
        string clause = column ~ " IN (" ~ placeholders ~ ")";
        
        if (_whereClauses.length == 0) {
            _whereClauses ~= "WHERE " ~ clause;
        } else {
            _whereClauses ~= "AND " ~ clause;
        }
        _parameters ~= values;
        return this;
    }

    IQueryBuilder whereNotIn(string column, SqlValue[] values) {
        import std.algorithm : map;
        import std.range : repeat;
        
        auto placeholders = "?".repeat(values.length).join(", ");
        string clause = column ~ " NOT IN (" ~ placeholders ~ ")";
        
        if (_whereClauses.length == 0) {
            _whereClauses ~= "WHERE " ~ clause;
        } else {
            _whereClauses ~= "AND " ~ clause;
        }
        _parameters ~= values;
        return this;
    }

    IQueryBuilder whereNull(string column) {
        string clause = column ~ " IS NULL";
        if (_whereClauses.length == 0) {
            _whereClauses ~= "WHERE " ~ clause;
        } else {
            _whereClauses ~= "AND " ~ clause;
        }
        return this;
    }

    IQueryBuilder whereNotNull(string column) {
        string clause = column ~ " IS NOT NULL";
        if (_whereClauses.length == 0) {
            _whereClauses ~= "WHERE " ~ clause;
        } else {
            _whereClauses ~= "AND " ~ clause;
        }
        return this;
    }

    IQueryBuilder join(string table, string condition, JoinType type = JoinType.INNER) {
        string joinType;
        final switch (type) {
            case JoinType.INNER:
                joinType = "INNER JOIN";
                break;
            case JoinType.LEFT:
                joinType = "LEFT JOIN";
                break;
            case JoinType.RIGHT:
                joinType = "RIGHT JOIN";
                break;
            case JoinType.FULL:
                joinType = "FULL JOIN";
                break;
            case JoinType.CROSS:
                joinType = "CROSS JOIN";
                break;
        }
        
        _joinClauses ~= joinType ~ " " ~ table ~ " ON " ~ condition;
        return this;
    }

    IQueryBuilder leftJoin(string table, string condition) {
        return join(table, condition, JoinType.LEFT);
    }

    IQueryBuilder rightJoin(string table, string condition) {
        return join(table, condition, JoinType.RIGHT);
    }

    IQueryBuilder groupBy(string[] columns...) {
        _groupByColumns = columns.dup;
        return this;
    }

    IQueryBuilder having(string condition) {
        _havingClause = condition;
        return this;
    }

    IQueryBuilder orderBy(string column, SortOrder order = SortOrder.ASC) {
        string orderStr = order == SortOrder.ASC ? "ASC" : "DESC";
        _orderByClauses ~= column ~ " " ~ orderStr;
        return this;
    }

    IQueryBuilder limit(size_t count) {
        _limitValue = count;
        return this;
    }

    IQueryBuilder offset(size_t count) {
        _offsetValue = count;
        return this;
    }

    IQueryBuilder insert(string table) {
        _queryType = QueryType.INSERT;
        _tableName = table;
        return this;
    }

    IQueryBuilder values(SqlValue[string] values) {
        _insertValues = values;
        return this;
    }

    IQueryBuilder update(string table) {
        _queryType = QueryType.UPDATE;
        _tableName = table;
        return this;
    }

    IQueryBuilder set(string column, SqlValue value) {
        _updateValues[column] = value;
        return this;
    }

    IQueryBuilder delete_() {
        _queryType = QueryType.DELETE;
        return this;
    }

    string toSql() const {
        final switch (_queryType) {
            case QueryType.SELECT:
                return buildSelect();
            case QueryType.INSERT:
                return buildInsert();
            case QueryType.UPDATE:
                return buildUpdate();
            case QueryType.DELETE:
                return buildDelete();
            case QueryType.CREATE:
            case QueryType.ALTER:
            case QueryType.DROP:
            case QueryType.TRUNCATE:
                return "";
        }
    }

    SqlValue[] parameters() const @trusted {
        return cast(SqlValue[])_parameters.dup;
    }

    QueryType queryType() const {
        return _queryType;
    }

    void reset() @trusted {
        _queryType = QueryType.SELECT;
        _selectColumns = [];
        _tableName = null;
        _whereClauses = [];
        _joinClauses = [];
        _groupByColumns = [];
        _havingClause = null;
        _orderByClauses = [];
        _limitValue = 0;
        _offsetValue = 0;
        _insertValues.clear();
        _updateValues.clear();
        _parameters = [];
    }

    protected string buildSelect() const {
        string sql = "SELECT ";
        
        if (_selectColumns.length > 0) {
            sql ~= _selectColumns.join(", ");
        } else {
            sql ~= "*";
        }
        
        sql ~= " FROM " ~ _tableName;
        
        if (_joinClauses.length > 0) {
            sql ~= " " ~ _joinClauses.join(" ");
        }
        
        if (_whereClauses.length > 0) {
            sql ~= " " ~ _whereClauses.join(" ");
        }
        
        if (_groupByColumns.length > 0) {
            sql ~= " GROUP BY " ~ _groupByColumns.join(", ");
        }
        
        if (_havingClause) {
            sql ~= " HAVING " ~ _havingClause;
        }
        
        if (_orderByClauses.length > 0) {
            sql ~= " ORDER BY " ~ _orderByClauses.join(", ");
        }
        
        if (_limitValue > 0) {
            sql ~= " LIMIT " ~ _limitValue.to!string;
        }
        
        if (_offsetValue > 0) {
            sql ~= " OFFSET " ~ _offsetValue.to!string;
        }
        
        return sql;
    }

    protected string buildInsert() const {
        import std.range : repeat;
        
        string sql = "INSERT INTO " ~ _tableName;
        
        if (_insertValues.length > 0) {
            auto columns = _insertValues.keys;
            auto placeholders = "?".repeat(_insertValues.length).join(", ");
            
            sql ~= " (" ~ columns.join(", ") ~ ")";
            sql ~= " VALUES (" ~ placeholders ~ ")";
        }
        
        return sql;
    }

    protected string buildUpdate() const {
        string sql = "UPDATE " ~ _tableName ~ " SET ";
        
        string[] setClauses;
        foreach (column, value; _updateValues) {
            setClauses ~= column ~ " = ?";
        }
        sql ~= setClauses.join(", ");
        
        if (_whereClauses.length > 0) {
            sql ~= " " ~ _whereClauses.join(" ");
        }
        
        return sql;
    }

    protected string buildDelete() const {
        string sql = "DELETE FROM " ~ _tableName;
        
        if (_whereClauses.length > 0) {
            sql ~= " " ~ _whereClauses.join(" ");
        }
        
        return sql;
    }
}
