/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.datasources.providers.base;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Base data source implementation
 */
abstract class BaseDataSource : UIMObject, IValueSource {
  protected string _name;
  protected DataSourceType _type;
  protected bool _isConnected = false;
  protected string[string] _schema;

  this(string sourceName, DataSourceType sourceType) {
    super();
    _name = sourceName;
    _type = sourceType;
  }

  string name() { return _name; }
  DataSourceType type() { return _type; }
  
  bool isAvailable() @safe {
    return _isConnected;
  }

  string[string] schema() {
    return _schema.dup;
  }

  abstract void connect(void delegate(bool success) @safe callback) @trusted;
  abstract void disconnect() @safe;
  abstract void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted;
  abstract void read(string query, void delegate(bool success, Json[] results) @safe callback) @trusted;
  abstract void write(Json data, void delegate(bool success, Json result) @safe callback) @trusted;
  abstract void count(void delegate(bool success, long count) @safe callback) @trusted;
}

/**
 * In-memory Json data source
 */
class JsonDataSource : BaseDataSource {
  protected Json[] _data;

  this(string sourceName, Json[] initialData = []) {
    super(sourceName, DataSourceType.Json);
    _data = initialData.dup;
    _isConnected = true;
  }

  void connect(void delegate(bool success) @safe callback) @trusted {
    _isConnected = true;
    callback(true);
  }

  void disconnect() @safe {
    _isConnected = false;
  }

  void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted {
    callback(true, _data.dup);
  }

  void read(string query, void delegate(bool success, Json[] results) @safe callback) @trusted {
    // Simple filtering - can be extended
    callback(true, _data.dup);
  }

  void write(Json data, void delegate(bool success, Json result) @safe callback) @trusted {
    _data ~= data;
    callback(true, data);
  }

  void count(void delegate(bool success, long count) @safe callback) @trusted {
    callback(true, cast(long)_data.length);
  }

  void setData(Json[] newData) {
    _data = newData.dup;
  }

  void addRecord(Json record) {
    _data ~= record;
  }
}


