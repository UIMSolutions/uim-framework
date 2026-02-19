/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.classes.views.view;

import uim.databases;

mixin(ShowModule!());

@safe:

/// Read-only view over a table with an attached filter/sort configuration.
class TableView : UIMObject, ITableView {
    private Table _table;
    private bool delegate(const ITableRow) @safe _filter;
    private string _orderBy = "";
    private bool _ascending = true;
    private size_t _limit = 0;
    private size_t _offset = 0;

    this(ITable table) {
        enforce(table !is null, "Table cannot be null");
        _table = table;
    }

    /// Configure filtering predicate.
    ITableView where(bool delegate(const ITableRow) @safe filter) {
        _filter = filter;
        return this;
    }

    /// Configure ordering.
    ITableView orderBy(string column, bool ascending = true) {
        _orderBy = column;
        _ascending = ascending;
        return this;
    }

    /// Configure pagination.
    ITableView limit(ulong count) {
        _limit = count;
        return this;
    }

    ITableView offset(ulong count) {
        _offset = count;
        return this;
    }

    /// Reset all view parameters.
    ITableView reset() {
        _filter = null;
        _orderBy = "";
        _ascending = true;
        _limit = 0;
        _offset = 0;
        return this;
    }

    /// Materialize the view as rows.
    ITableRow[] materialize() {
        return _table.select(_filter, _orderBy, _ascending, _limit, _offset);
    }

    /// Count rows after applying filter.
    size_t count() {
        return _table.count(_filter);
    }

    /// Get the underlying table.
    ITable table() {
        return _table;
    }
}
