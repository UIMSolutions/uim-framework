module uim.databases.classes.engines.engine;

import uim.databases;

@safe:

class DatabaseEngine : UIMObject {
    // Implementation of Engine class

    abstract Table createTable(string name, string[] columns) @safe;
    
    abstract Table getTable(string name) @safe;

    abstract bool hasTable(string name) const @safe;;
    
    abstract void dropTable(string name) @safe;

    abstract string[] tableNames() const @safe;

    abstract ulong rowCount() const @safe;

    abstract void clear() @safe;

    abstract const(Table[string]) tables() const @safe;
}
