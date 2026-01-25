module uim.databases.classes.engines.memory;

import uim.databases;
import std.exception : enforce;
@safe:

class MemoryEngine : DatabaseEngine {
    private Table[string] _tables;

    override Table createTable(string name, string[] columns) @safe {
        enforce(name.length > 0, "Table name cannot be empty");
        enforce(!(name in _tables), "Table already exists: " ~ name);
        
        auto table = new Table(name, columns);
        _tables[name] = table;
        return table;
    }

    override Table getTable(string name) @safe {
        return _tables.get(name, null);
    }

    override bool hasTable(string name) const @safe {
        return (name in _tables) !is null;
    }

    override void dropTable(string name) @safe {
        _tables.remove(name);
    }

    override string[] tableNames() const @safe {
        return _tables.keys.dup;
    }

    override ulong rowCount() const @safe {
        ulong total = 0;
        foreach (table; _tables.byValue()) {
            total += table.rowCount();
        }
        return total;
    }

    override void clear() @safe {
        foreach (table; _tables.byValue()) {
            table.clear();
        }
        _tables.clear();
    }

    override const(Table[string]) tables() const @safe { 
        return _tables; 
    }
}