/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.orm.interfaces.model;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * ORM Model interface
 */
interface IORMModel {
  /**
   * Get the table name for this model
   */
  string tableName();

  /**
   * Get the primary key field name
   */
  string primaryKey();

  /**
   * Get column mappings
   */
  string[string] columnMappings();

  /**
   * Get timestamps enabled status
   */
  bool hasTimestamps();

  /**
   * Find a model by primary key
   */
  void find(long id, void delegate(bool success, IEntity entity) @safe callback) @trusted;

  /**
   * Find all models
   */
  void all(void delegate(bool success, IEntity[] entities) @safe callback) @trusted;

  /**
   * Create a new model instance
   */
  void create(IEntity entity, void delegate(bool success, IEntity result) @safe callback) @trusted;

  /**
   * Update a model instance
   */
  void update(IEntity entity, void delegate(bool success, IEntity result) @safe callback) @trusted;

  /**
   * Delete a model instance
   */
  void delete(IEntity entity, void delegate(bool success) @safe callback) @trusted;

  /**
   * Get query builder for this model
   */
  IQuery query();

  /**
   * Get the database connection
   */
  IDatabase database();
}
