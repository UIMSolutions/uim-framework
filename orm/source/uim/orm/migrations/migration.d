/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.orm.migrations.migration;

import uim.orm;

mixin(ShowModule!());

@safe:

/**
 * Migration interface for database schema management
 */
interface IMigration {
  /**
   * Get migration name/identifier
   */
  string name();

  /**
   * Run the migration (apply changes)
   */
  void up(IDatabase database, void delegate(bool success) @safe callback) @trusted;

  /**
   * Rollback the migration (undo changes)
   */
  void down(IDatabase database, void delegate(bool success) @safe callback) @trusted;
}

/**
 * Base migration class
 */
abstract class Migration : UIMObject, IMigration {
  protected string _name;

  this(string migrationName) {
    super();
    _name = migrationName;
  }

  string name() {
    return _name;
  }

  abstract void up(IDatabase database, void delegate(bool success) @safe callback) @trusted;
  abstract void down(IDatabase database, void delegate(bool success) @safe callback) @trusted;
}

/**
 * Migration runner for executing migrations
 */
class MigrationRunner : UIMObject {
  protected IMigration[] _migrations;
  protected IDatabase _database;
  protected string[] _executed;

  this(IDatabase database) {
    super();
    _database = database;
  }

  void registerMigration(IMigration migration) {
    _migrations ~= migration;
  }

  void runPending(void delegate(bool success, string[] executed) @safe callback) @trusted {
    if (_migrations.length == 0) {
      callback(true, []);
      return;
    }

    string[] executedMigrations;
    size_t completed = 0;

    foreach (migration; _migrations) {
      migration.up(_database, (bool success) {
        completed++;
        if (success) {
          executedMigrations ~= migration.name();
        }

        if (completed == _migrations.length) {
          callback(success, executedMigrations);
        }
      });
    }
  }

  void rollback(void delegate(bool success) @safe callback) @trusted {
    if (_executed.length == 0) {
      callback(true);
      return;
    }

    size_t completed = 0;
    size_t totalToRollback = _executed.length;

    foreach_reverse (migrationName; _executed) {
      foreach (migration; _migrations) {
        if (migration.name() == migrationName) {
          migration.down(_database, (bool success) {
            completed++;
            if (completed == totalToRollback) {
              callback(true);
            }
          });
          break;
        }
      }
    }
  }
}
