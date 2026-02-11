/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.interfaces.query;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Extended DAO interface with query capabilities.
 */
interface IQueryableDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Find entities matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: Array of matching entities
   */
  T[] findWhere(bool delegate(T) @safe predicate);

  /**
   * Find the first entity matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: The first matching entity or null
   */
  T findFirst(bool delegate(T) @safe predicate);

  /**
   * Count entities matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: The count of matching entities
   */
  size_t countWhere(bool delegate(T) @safe predicate);
}