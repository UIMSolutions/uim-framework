module uim.databases.classes.rows.row;

import uim.databases;
@safe:

class TableRow : UIMObject {
    this() {
        super();
    }

    Json[string] _cells;
    
    this(Json[string] cells) {
        _cells = cells.dup;
    }
    
    this(Row data) {
        this._cells = data.dup;
    }

    Json[string] getData() @safe {
        return _cells.dup;
    }

    void setData(Row newData) @safe {
        _cells = newData.dup;
    }
}