/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datasources.queries.filter;

import uim.datasources;
import std.format : format;

mixin(ShowModule!());

@safe:

/**
 * Filter condition
 */
class FilterCondition {
  string field;
  FilterOperator op;
  Json value;
  string logicalOp; // AND or OR

  this(string f, FilterOperator operation, Json v, string logical = "AND") {
    field = f;
    op = operation;
    value = v;
    logicalOp = logical;
  }

  string toString() {
    string opStr = op.to!string;
    return format("%s %s %s", field, opStr, value.to!string);
  }
}

/**
 * Data filter implementation
 */
class DataFilter : UIMObject, IFilter {
  protected FilterCondition[] _conditions;
  protected string[] _orderBy;
  protected size_t _limitValue = 0;
  protected size_t _offsetValue = 0;

  this() {
    super();
  }

  IFilter where(string field, FilterOperator op, Json value) {
    _conditions = [];
    _conditions ~= new FilterCondition(field, op, value, "AND");
    return this;
  }

  IFilter and(string field, FilterOperator op, Json value) {
    _conditions ~= new FilterCondition(field, op, value, "AND");
    return this;
  }

  IFilter or(string field, FilterOperator op, Json value) {
    _conditions ~= new FilterCondition(field, op, value, "OR");
    return this;
  }

  IFilter orderBy(string field, string direction = "ASC") {
    _orderBy ~= format("%s %s", field, direction);
    return this;
  }

  IFilter limit(size_t count) {
    _limitValue = count;
    return this;
  }

  IFilter offset(size_t count) {
    _offsetValue = count;
    return this;
  }

  Json toJson() {
    Json result = Json.emptyObject();
    
    if (_conditions.length > 0) {
      Json[] condArr;
      foreach (cond; _conditions) {
        Json c = Json.emptyObject();
        c["field"] = Json(cond.field);
        c["operator"] = Json(cond.op.to!string);
        c["value"] = cond.value;
        c["logical"] = Json(cond.logicalOp);
        condArr ~= c;
      }
      result["conditions"] = Json(condArr);
    }

    if (_orderBy.length > 0) {
      result["orderBy"] = Json(_orderBy);
    }

    if (_limitValue > 0) {
      result["limit"] = Json(_limitValue);
    }

    if (_offsetValue > 0) {
      result["offset"] = Json(_offsetValue);
    }

    return result;
  }

  string toQueryString() {
    string query = "";

    if (_conditions.length > 0) {
      foreach (i, cond; _conditions) {
        if (i > 0) {
          query ~= " " ~ cond.logicalOp ~ " ";
        }
        query ~= cond.toString();
      }
    }

    if (_orderBy.length > 0) {
      query ~= " ORDER BY " ~ _orderBy.join(", ");
    }

    if (_limitValue > 0) {
      query ~= format(" LIMIT %d", _limitValue);
    }

    if (_offsetValue > 0) {
      query ~= format(" OFFSET %d", _offsetValue);
    }

    return query;
  }

  void reset() {
    _conditions = [];
    _orderBy = [];
    _limitValue = 0;
    _offsetValue = 0;
  }
}
