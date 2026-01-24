/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.base.database;

import uim.databases.interfaces.database;
import uim.databases.base.table;
import std.variant : Variant;
import std.algorithm : map;
import std.array : array;

class InMemoryDatabase : IDatabase {
    private Table[string] _tables;

    Table createTable(string name, string[] columns) @safe {
        auto table = new Table(name, columns);
        _tables[name] = table;
        return table;
    }

    Table getTable(string name) @safe {
        return _tables.get(name, null);
    }

    bool hasTable(string name) const @safe {
        return (name in _tables) !is null;
    }

    void dropTable(string name) @safe {
        _tables.remove(name);
    }

    string[] tableNames() const @safe {
        return _tables.keys.dup;
    }

    ulong rowCount() const @safe {
        ulong total = 0;
        foreach (table; _tables) {
            total += table.rowCount();
        }
        return total;
    }

    void clear() @safe {
        _tables.clear();
    }

    @property const(Table[string]) tables() const @safe { 
        return _tables; 
    }
}
