/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.orm.interfaces.query;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * Query builder interface for building SQL queries
 */
interface IQuery {
  /**
   * Add select columns
   */
  IQuery select(string[] columns...);

  /**
   * Set table to query
   */
  IQuery from(string table);

  /**
   * Add a WHERE condition
   */
  IQuery where(string condition);

  /**
   * Add a WHERE condition with parameters
   */
  IQuery where(string condition, Json[string] params);

  /**
   * Add an AND condition
   */
  IQuery and(string condition);

  /**
   * Add an OR condition
   */
  IQuery or(string condition);

  /**
   * Add an ORDER BY clause
   */
  IQuery orderBy(string column, string direction = "ASC");

  /**
   * Add a LIMIT clause
   */
  IQuery limit(size_t count);

  /**
   * Add an OFFSET clause
   */
  IQuery offset(size_t count);

  /**
   * Add a GROUP BY clause
   */
  IQuery groupBy(string[] columns...);

  /**
   * Add a HAVING clause
   */
  IQuery having(string condition);

  /**
   * Add a JOIN clause
   */
  IQuery join(string table, string condition, string type = "INNER");

  /**
   * Get the built SQL query string
   */
  string toSql();

  /**
   * Get query parameters
   */
  Json[string] params();

  /**
   * Execute the query asynchronously
   */
  void execute(void delegate(bool success, Json result) @safe callback) @trusted;

  /**
   * Get the first result
   */
  void first(void delegate(bool success, Json result) @safe callback) @trusted;

  /**
   * Get all results
   */
  void get(void delegate(bool success, Json[] results) @safe callback) @trusted;

  /**
   * Get the count of results
   */
  void count(void delegate(bool success, long count) @safe callback) @trusted;
}
