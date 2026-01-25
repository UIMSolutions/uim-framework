module uim.databases.classes.engines.memory;

import uim.databases;
@safe:

class MemoryEngine : DatabaseEngine {
    private Table[string] _tables;

    override Table createTable(string name, string[] columns) @safe {
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
        foreach (table; _tables) {
            total += table.rowCount();
        }
        return total;
    }

    override void clear() @safe {
        _tables.clear();
    }

    override const(Table[string]) tables() const @safe { 
        return _tables; 
    }
}