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

  @property Json[string] data() const {
    // Create a mutable copy from const data
    Json[string] result;
    foreach (key, val; _cells) {
      result[key] = val;
    }
    return result;
  }

  @property void data(Json[string] values) {
    _cells = values.dup;
  }

  Json[string] getData() {
    return _cells.dup;
  }

  ITableRow setData(Json[string] newData) {
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

  void opIndexAssign(Json value, string column) {
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
///
unittest {
  auto row = new TableRow();
  assert(row.empty);

  row.set("id", 123);
  row.set("name", "Alice");
  assert(row.get("id") == 123);
  assert(row.get("name") == "Alice");
  assert(row.columns.length == 2);

  row.remove("id");
  assert(!row.has("id"));
  assert(row.has("name"));

  row.clear();
  assert(row.empty);
}
