/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.classes.engines.memory;

import uim.databases;

mixin(ShowModule!());

@safe:

class MemoryEngine : DatabaseEngine {
  private Table[string] _tables;

  override Table createTable(string name, string[] columns) {
    enforce(name.length > 0, "Table name cannot be empty");
    enforce(!(name in _tables), "Table already exists: " ~ name);

    auto table = new Table(name, columns);
    _tables[name] = table;
    return table;
  }

  override Table getTable(string name) {
    return _tables.get(name, null);
  }

  override bool hasTable(string name) const {
    return (name in _tables) !is null;
  }

  override void dropTable(string name) {
    _tables.remove(name);

  }

  override string[] tableNames() const {
    return _tables.keys.dup;
  }

  override ulong rowCount() const {
    ulong total = 0;
    foreach (table; _tables.byValue()) {
      total += table.rowCount();
    }
    return total;
  }

  override void clear() {
    foreach (table; _tables.byValue()) {
      table.clear();
    }
    _tables.clear();

  }

  override const(Table[string]) tables() const {
    return _tables;
  }
}
