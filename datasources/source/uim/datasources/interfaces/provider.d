/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.datasources.interfaces.provider;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Data provider interface for managing multiple data sources
 */
interface IValueProvider {
  /**
   * Register a data source
   */
  IValueProvider registerSource(string sourceName, IValueSource source);

  /**
   * Get a registered data source
   */
  IValueSource getSource(string sourceName);

  /**
   * Check if source is registered
   */
  bool hasSource(string sourceName);

  /**
   * Get all registered sources
   */
  IValueSource[] getAllSources();

  /**
   * Query data from a source
   */
  void query(string sourceName, string query, void delegate(bool success, Json[] results) @safe callback) @trusted;

  /**
   * Get data with filters
   */
  void fetch(string sourceName, void delegate(bool success, Json[] results) @safe callback) @trusted;

  /**
   * Write data to source
   */
  void persist(string sourceName, Json data, void delegate(bool success, Json result) @safe callback) @trusted;

  /**
   * Check availability of all sources
   */
  bool areSourcesAvailable() @safe;
}
