module uim.databases.classes.engines.engine;

import uim.databases;

mixin(ShowModule!());

@safe:

class DatabaseEngine : UIMObject, IDatabaseEngine {
    // Implementation of Engine class

    abstract Table createTable(string name, string[] columns);
    
    abstract Table getTable(string name);

    abstract bool hasTable(string name) const;;
    
    abstract void dropTable(string name);

    abstract string[] tableNames() const;

    abstract ulong rowCount() const;

    abstract void clear();

    abstract const(Table[string]) tables() const;
}
