/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.orm.connections.base;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * Base database connection class
 */
abstract class BaseDatabase : UIMObject, IDatabase {
  protected string _driver;
  protected string _host;
  protected ushort _port;
  protected string _database;
  protected string _username;
  protected string _password;
  protected bool _isConnected = false;
  protected long _lastInsertId = 0;
  protected long _affectedRows = 0;

  this(string driver, string host, ushort port, string database, string username, string password) {
    super();
    _driver = driver;
    _host = host;
    _port = port;
    _database = database;
    _username = username;
    _password = password;
  }

  string driver() {
    return _driver;
  }

  bool isConnected() @safe {
    return _isConnected;
  }

  long lastInsertId() @safe {
    return _lastInsertId;
  }

  long affectedRows() @safe {
    return _affectedRows;
  }

  abstract void connect() @trusted;
  abstract void disconnect() @trusted;
  abstract void query(string sql, void delegate(bool success, Json result) @safe callback) @trusted;
  abstract void query(string sql, Json[string] params, void delegate(bool success, Json result) @safe callback) @trusted;
  abstract void beginTransaction() @trusted;
  abstract void commit() @trusted;
  abstract void rollback() @trusted;
  abstract void closePrepared(string statementId) @trusted;
}

/**
 * Connection pool for managing database connections
 */
class DatabaseConnectionPool : UIMObject {
  protected IDatabase[string] _connections;
  protected size_t _maxConnections = 10;
  protected size_t[string] _connectionCounts;

  this(size_t maxConns = 10) {
    super();
    _maxConnections = maxConns;
  }

  IDatabase getConnection(string connectionName) {
    if (auto ptr = connectionName in _connections) {
      return *ptr;
    }
    return null;
  }

  void registerConnection(string connectionName, IDatabase connection) {
    if (_connections.length < _maxConnections) {
      _connections[connectionName] = connection;
      _connectionCounts[connectionName] = 0;
    }
  }

  void releaseConnection(string connectionName) {
    if (connectionName in _connectionCounts) {
      _connectionCounts[connectionName]--;
    }
  }

  size_t activeConnections(string connectionName) {
    if (auto ptr = connectionName in _connectionCounts) {
      return *ptr;
    }
    return 0;
  }
}
