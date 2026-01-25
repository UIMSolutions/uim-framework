module uim.databases.classes.columns.column;

import uim.databases;
@safe:

class TableColumns : UIMObject {
    string name;
    string type;

    this(string name, string type) {
        this.name = name;
        this.type = type;
    }
}
