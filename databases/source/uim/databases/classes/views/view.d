module uim.databases.classes.view;

import uim.databases;
@safe:


/// Read-only view over a table with an attached filter/sort configuration.
class View : UIMObject {
    private Table _table;
    private bool delegate(const Row) @safe _filter;
    private string _orderBy = "";
    private bool _ascending = true;
    private ulong _limit = 0;
    private ulong _offset = 0;

    this(Table table) @safe {
        _table = table;
    }

    /// Configure filtering predicate.
    View where(bool delegate(const Row) @safe filter) @safe {
        _filter = filter;
        return this;
    }

    /// Configure ordering.
    View orderBy(string column, bool ascending = true) @safe {
        _orderBy = column;
        _ascending = ascending;
        return this;
    }

    /// Configure pagination.
    View limit(ulong count) @safe { _limit = count; return this; }
    View offset(ulong count) @safe { _offset = count; return this; }

    /// Materialize the view as rows.
    Row[] materialize() @safe {
        return _table.select(_filter, _orderBy, _ascending, _limit, _offset);
    }

    /// Count rows after applying filter.
    ulong count() @safe {
        return _table.count(_filter);
    }
}