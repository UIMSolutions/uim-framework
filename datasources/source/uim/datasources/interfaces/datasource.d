/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datasources.interfaces.datasource;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Data source type enumeration
 */
enum DataSourceType {
  Json,
  CSV,
  Database,
  REST,
  XML,
  YAML
}

/**
 * Data source interface for reading from various sources
 */
interface IValueSource {
  /**
   * Get data source name
   */
  string name();

  /**
   * Get data source type
   */
  DataSourceType type();

  /**
   * Check if data source is connected/available
   */
  bool isAvailable() @safe;

  /**
   * Connect to data source
   */
  void connect(void delegate(bool success) @safe callback) @trusted;

  /**
   * Disconnect from data source
   */
  void disconnect() @safe;

  /**
   * Read all data from source
   */
  void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted;

  /**
   * Read data with query
   */
  void read(string query, void delegate(bool success, Json[] results) @safe callback) @trusted;

  /**
   * Write data to source
   */
  void write(Json data, void delegate(bool success, Json result) @safe callback) @trusted;

  /**
   * Count records in source
   */
  void count(void delegate(bool success, long count) @safe callback) @trusted;

  /**
   * Get schema/structure of data source
   */
  string[string] schema();
}

/**
 * Data result wrapper
 */
class DataResult {
  bool success;
  Json[] data;
  string error;
  size_t totalRecords;
  size_t pageNumber;
  size_t pageSize;
  SysTime timestamp;
  double executionTime;

  this() {
    success = false;
    data = [];
    error = "";
    totalRecords = 0;
    pageNumber = 1;
    pageSize = 10;
    timestamp = Clock.currTime();
    executionTime = 0.0;
  }

  bool isSuccessful() { return success; }
  bool hasError() { return error.length > 0; }
  size_t recordCount() { return data.length; }
  size_t totalPages() {
    if (pageSize == 0) return 0;
    return (totalRecords + pageSize - 1) / pageSize;
  }
}
