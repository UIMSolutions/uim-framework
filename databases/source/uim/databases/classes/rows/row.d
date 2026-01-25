module uim.databases.classes.rows.row;

import uim.databases;

@safe:

class TableRow : UIMObject, ITableRow {
    this() {
        super();
    }

    protected Json[string] _cells;

    this(Json[string] cells) {
        _cells = cells.dup;
    }

    this(TableRow data) {
        this._cells = data.dup;
    }

    @property Json[string] data() const {
        return _cells.dup;
    }

    @property ITableRow data(Json[string] values) {
        _cells = values.dup;
        return this;
    }

    Json getData() {
        return _cells.dup;
    }

    ITableRow setData(TableRow newData) {
        _cells = newData.dup;
        return this;
    }

    Json get(string column) const {
        return column in _cells ? _cells[column] : Json(null);
    }

    ITableRow set(string column, Json value) {
        _cells[column] = value;
        return this;
    }

    bool has(string column) const {
        return (column in _cells) !is null;
    }

    ITableRow remove(string column) {
        _cells.remove(column);
        return this;

    }

    @property string[] columns() const {
        return _cells.keys;
    }

    @property size_t columnCount() const {
        return _cells.length;
    }

    ITableRow clear() {
        _cells.clear();
        return this;
    }

    @property bool empty() const {
        return _cells.length == 0;
    }

    Json opIndex(string column) {
        return get(column);
    }

    Json data(string column) {
        return get(column);
    }

    ITableRow opIndexAssign(Json value, string column) {
        set(column, value);
    }

    ITableRow data(string column, Json value) {
        set(column, value);
    }

    override string toString() {
        import std.conv : to;
        import std.array : join;

        string[] parts;
        foreach (col, val; _cells) {
            parts ~= col ~ ": " ~ val.to!string;
        }
        return "{" ~ parts.join(", ") ~ "}";
    }
}
