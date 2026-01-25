module uim.databases.classes.columns.column;

import uim.databases;
@safe:

class Column : UIMObject {
    string name;
    string type;

    this(string name, string type) {
        this.name = name;
        this.type = type;
    }
}
