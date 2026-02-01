/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.orm.interfaces.database;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * Database connection interface
 */
interface IDatabase {
  /**
   * Get the database driver type (mysql, sqlite, postgresql, etc.)
   */
  string driver();

  /**
   * Check if connection is open
   */
  bool isConnected() @safe;

  /**
   * Connect to the database
   */
  void connect() @trusted;

  /**
   * Disconnect from the database
   */
  void disconnect() @trusted;

  /**
   * Execute a raw SQL query asynchronously
   */
  void query(string sql, void delegate(bool success, Json result) @safe callback) @trusted;

  /**
   * Execute a raw SQL query with parameters
   */
  void query(string sql, Json[string] params, void delegate(bool success, Json result) @safe callback) @trusted;

  /**
   * Begin a database transaction
   */
  void beginTransaction() @trusted;

  /**
   * Commit the current transaction
   */
  void commit() @trusted;

  /**
   * Rollback the current transaction
   */
  void rollback() @trusted;

  /**
   * Close prepared statement
   */
  void closePrepared(string statementId) @trusted;

  /**
   * Get last insert ID
   */
  long lastInsertId() @safe;

  /**
   * Get the number of affected rows
   */
  long affectedRows() @safe;
}
