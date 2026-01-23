module uim.database.inmemory;

import std.container : RedBlackTree;
import std.variant : Variant;
import std.algorithm : filter;
import std.array : array;

alias Row = Variant[string];

class Table {
    private string _name;
    private string[] _columns;
    private Row[] _rows;

    this(string name, string[] columns) {
        _name = name;
        _columns = columns.dup;
    }

    @property string name() const { return _name; }
    @property const(string[]) columns() const { return _columns; }
    @property const(Row[]) rows() const { return _rows; }

    void insert(Row row) {
        _rows ~= row;
    }

    Row[] select(bool delegate(const Row) filter = null) const {
        if (filter is null) {
            return _rows.dup;
        }
        return _rows.filter!(r => filter(r)).array;
    }

    void delete_(bool delegate(const Row) filter) {
        _rows = _rows.filter!(r => !filter(r)).array;
    }
}

class InMemoryDatabase {
    private Table[string] _tables;

    Table createTable(string name, string[] columns) {
        auto table = new Table(name, columns);
        _tables[name] = table;
        return table;
    }

    Table getTable(string name) {
        return _tables.get(name, null);
    }

    void dropTable(string name) {
        _tables.remove(name);
    }

    @property const(Table[string]) tables() const { return _tables; }
}
