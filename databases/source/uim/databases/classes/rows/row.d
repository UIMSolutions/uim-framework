module uim.databases.classes.rows.row;

import uim.databases;

mixin(ShowModule!());

@safe:

class TableRow : UIMObject, ITableRow {
  this() {
    super();
  }

  protected Json[string] _cells;

  this(Json[string] cells) {
    _cells = cells.dup;
  }

  this(ITableRow data) {
    this._cells = data.data.dup;
  }

  Json[string] data() const {
    // Create a mutable copy from const data
    Json[string] result;
    foreach (key, val; _cells) {
      result[key] = val;
    }
    return result;
  }

  ITableRow data(Json[string] values) {
    _cells = values.dup;
    return this;
  }

  Json[string] getData() {
    return _cells.dup;
  }

  Json get(string column) const {
    return column in _cells ? _cells[column] : Json(null);
  }

  ITableRow data(string column, Json value) {
    _cells[column] = value;
    return this;
  }

  bool hasColumn(string column) const {
    return (column in _cells) !is null;
  }

  ITableRow remove(string column) {
    _cells.remove(column);
    return this;
  }

  string[] columns() const {
    return _cells.keys;
  }

  size_t columnCount() const {
    return _cells.length;
  }

  ITableRow clear() {
    _cells.clear();
    return this;
  }

  bool empty() const {
    return _cells.length == 0;
  }

  Json opIndex(string column) {
    return get(column);
  }

  void opIndexAssign(Json value, string column) {
    data(column, value);
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
///
unittest {
  auto row = new TableRow();
  assert(row.empty);

  row.data("id", Json(123));
  row.data("name", Json("Alice"));
  assert(row.get("id") == Json(123));
  assert(row.get("name") == Json("Alice"));
  assert(row.columns.length == 2);

  row.remove("id");
  assert(!row.has("id"));
  assert(row.has("name"));

  row.clear();
  assert(row.empty);
}
