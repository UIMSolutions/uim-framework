/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.interfaces.batch;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Batch operations interface for DAO.
 */
interface IBatchDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Save multiple entities.
   * Params:
   *   entities = The entities to save
   * Returns: The saved entities
   */
  T[] saveAll(T[] entities);

  /**
   * Update multiple entities.
   * Params:
   *   entities = The entities to update
   * Returns: The updated entities
   */
  T[] updateAll(T[] entities);

  /**
   * Delete multiple entities by their identifiers.
   * Params:
   *   ids = The identifiers of entities to delete
   * Returns: The number of deleted entities
   */
  size_t deleteAllById(ID[] ids);

  /**
   * Delete all entities matching a predicate.
   * Params:
   *   predicate = The filter predicate
   * Returns: The number of deleted entities
   */
  size_t deleteWhere(bool delegate(T) @safe predicate);
}
