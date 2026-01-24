/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.datasources.interfaces.filter;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Filter operator enumeration
 */
enum FilterOperator {
  Equal,
  NotEqual,
  GreaterThan,
  GreaterThanOrEqual,
  LessThan,
  LessThanOrEqual,
  In,
  NotIn,
  Contains,
  NotContains,
  StartsWith,
  EndsWith,
  Between,
  IsNull,
  IsNotNull
}

/**
 * Data filter for querying
 */
interface IFilter {
  /**
   * Add a filter condition
   */
  IFilter where(string field, FilterOperator op, Json value);

  /**
   * Add multiple conditions (AND)
   */
  IFilter and(string field, FilterOperator op, Json value);

  /**
   * Add OR condition
   */
  IFilter or(string field, FilterOperator op, Json value);

  /**
   * Set order by
   */
  IFilter orderBy(string field, string direction = "ASC");

  /**
   * Set limit
   */
  IFilter limit(size_t count);

  /**
   * Set offset/skip
   */
  IFilter offset(size_t count);

  /**
   * Get filters as JSON
   */
  Json toJson();

  /**
   * Convert to query string
   */
  string toQueryString();

  /**
   * Reset all filters
   */
  void reset();
}
