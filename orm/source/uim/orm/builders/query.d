/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.orm.builders.query;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * SQL Query builder for constructing queries
 */
class SQLQueryBuilder : UIMObject, IQuery {
  protected string _table;
  protected string[] _columns;
  protected string[] _wheres;
  protected Json[string] _params;
  protected string[] _orderBy;
  protected size_t _limitValue = 0;
  protected size_t _offsetValue = 0;
  protected string[] _groupBy;
  protected string[] _joins;
  protected string _having;
  protected IDatabase _database;

  this(IDatabase database) {
    super();
    _database = database;
    _columns = ["*"];
  }

  IQuery select(string[] columns...) {
    _columns = columns.length > 0 ? columns.dup : ["*"];
    return this;
  }

  IQuery from(string table) {
    _table = table;
    return this;
  }

  IQuery where(string condition) {
    _wheres ~= condition;
    return this;
  }

  IQuery where(string condition, Json[string] params) {
    _wheres ~= condition;
    foreach (key, value; params) {
      _params[key] = value;
    }
    return this;
  }

  IQuery and(string condition) {
    if (_wheres.length > 0) {
      _wheres[$-1] ~= " AND " ~ condition;
    } else {
      _wheres ~= condition;
    }
    return this;
  }

  IQuery or(string condition) {
    if (_wheres.length > 0) {
      _wheres[$-1] ~= " OR " ~ condition;
    } else {
      _wheres ~= condition;
    }
    return this;
  }

  IQuery orderBy(string column, string direction = "ASC") {
    _orderBy ~= column ~ " " ~ direction;
    return this;
  }

  IQuery limit(size_t count) {
    _limitValue = count;
    return this;
  }

  IQuery offset(size_t count) {
    _offsetValue = count;
    return this;
  }

  IQuery groupBy(string[] columns...) {
    _groupBy = columns.dup;
    return this;
  }

  IQuery having(string condition) {
    _having = condition;
    return this;
  }

  IQuery join(string table, string condition, string type = "INNER") {
    _joins ~= type ~ " JOIN " ~ table ~ " ON " ~ condition;
    return this;
  }

  string toSql() {
    string sql = "SELECT ";
    sql ~= _columns.join(", ");
    sql ~= " FROM " ~ _table;

    if (_joins.length > 0) {
      sql ~= " " ~ _joins.join(" ");
    }

    if (_wheres.length > 0) {
      sql ~= " WHERE " ~ _wheres.join(" ");
    }

    if (_groupBy.length > 0) {
      sql ~= " GROUP BY " ~ _groupBy.join(", ");
    }

    if (_having.length > 0) {
      sql ~= " HAVING " ~ _having;
    }

    if (_orderBy.length > 0) {
      sql ~= " ORDER BY " ~ _orderBy.join(", ");
    }

    if (_limitValue > 0) {
      sql ~= " LIMIT " ~ _limitValue.to!string;
    }

    if (_offsetValue > 0) {
      sql ~= " OFFSET " ~ _offsetValue.to!string;
    }

    return sql;
  }

  Json[string] params() {
    return _params.dup;
  }

  void execute(void delegate(bool success, Json result) @safe callback) @trusted {
    _database.query(toSql(), _params, callback);
  }

  void first(void delegate(bool success, Json result) @safe callback) @trusted {
    limit(1);
    execute((bool success, Json result) @safe {
      if (success && result.type == Json.Type.array && result.length > 0) {
        callback(true, result[0]);
      } else {
        callback(false, Json(null));
      }
    });
  }

  void get(void delegate(bool success, Json[] results) @safe callback) @trusted {
    execute((bool success, Json result) @safe {
      if (success && result.type == Json.Type.array) {
        callback(true, result.get!(Json[]));
      } else {
        callback(false, []);
      }
    });
  }

  void count(void delegate(bool success, long count) @safe callback) @trusted {
    // Reset columns and set count
    auto oldColumns = _columns;
    _columns = ["COUNT(*) as count"];

    execute((bool success, Json result) @safe {
      _columns = oldColumns;
      if (success && result.type == Json.Type.array && result.length > 0) {
        callback(true, result[0]["count"].get!long);
      } else {
        callback(false, 0);
      }
    });
  }
}
