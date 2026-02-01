/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.classes.engines.engine;

import uim.databases;

mixin(ShowModule!());

@safe:

class DatabaseEngine : UIMObject, IValuebaseEngine {
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
