/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Plain text / CSV tables for terminal output.
module uim.service.presentation.cli.table;

import std.array : appender;
import std.utf : count;
import uim.service;

mixin(ShowModule!());

@safe:

/// Display text of a JSON cell value.
string cellText(Json value) {
  switch (value.type) {
  case Json.Type.string:
    return value.get!string;
  case Json.Type.null_, Json.Type.undefined:
    return "";
  case Json.Type.array:
    return value.get!(Json[]).map!(v => v.isObject ? v.toString : cellText(v)).join(", ");
  default:
    return value.toString;
  }
}

struct TextTable {
  string[] headers;
  string[][] rows;

  size_t length() const {
    return rows.length;
  }

  /// Build from JSON rows; headers default to the column names.
  static TextTable fromRows(const Json[] data, const string[] columns, const string[] headers = null) @trusted {
    TextTable t;
    t.headers = headers.length == columns.length ? headers.dup : columns.dup;
    foreach (row; data) {
      string[] cells;
      foreach (c; columns)
        cells ~= row.type == Json.Type.object && c in row ? cellText(row[c]) : "";
      t.rows ~= cells;
    }
    return t;
  }

  /// Two column key/value table of an object (keys in the given order, then the rest).
  static TextTable keyValue(Json object, const string[] order = null, string delegate(string) @safe label = null) @trusted {
    TextTable t;
    t.headers = ["Property", "Value"];
    if (!object.isObject)
      return t;
    string[] keys = order.filter!(k => k in object).array.dup;
    foreach (k; object.get!(Json[string]).keys.sort)
      if (!keys.canFind(k))
        keys ~= k;
    foreach (k; keys)
      t.rows ~= [label is null ? k : label(k), cellText(object[k])];
    return t;
  }

  /// Render as aligned plain text; cells are cut at maxWidth characters.
  string render(size_t maxWidth = 48) const @trusted {
    auto widths = headers.map!(h => h.count).array;
    foreach (r; rows)
      foreach (i, c; r)
        if (i < widths.length)
          widths[i] = max(widths[i], min(c.count, maxWidth));

    string cell(string s, size_t w) {
      s = s.replace("\n", " ");
      auto n = s.count;
      if (n > w) {
        import std.range : take;
        import std.conv : text;

        return s.take(w - 1).text ~ "…";
      }
      return s ~ ' '.repeat(w - n).array.idup;
    }

    auto buf = appender!string;
    void line(const string[] cells) {
      string text;
      foreach (i, w; widths)
        text ~= (i ? "  " : "") ~ cell(i < cells.length ? cells[i] : "", w);
      buf.put(text.stripRight ~ "\n");
    }

    line(headers);
    line(widths.map!(w => '-'.repeat(w).array.idup).array);
    foreach (r; rows)
      line(r);
    return buf.data;
  }

  /// Render as RFC 4180 CSV.
  string renderCsv() const {
    string esc(string s) {
      return s.canFind(",") || s.canFind("\"") || s.canFind("\n") ? "\"" ~ s.replace("\"", "\"\"") ~ "\"" : s;
    }

    auto buf = appender!string;
    buf.put(headers.map!(h => esc(h)).join(",") ~ "\n");
    foreach (r; rows)
      buf.put(r.map!(c => esc(c)).join(",") ~ "\n");
    return buf.data;
  }
}

///
unittest {
  mixin(ShowTest!("TextTable"));

  auto rows = [parseJsonString(`{"id":"1","name":"Ä long name","tags":["a","b"]}`), parseJsonString(`{"id":"2"}`)];
  auto t = TextTable.fromRows(rows, ["name", "tags", "id"], ["Name", "Tags", "ID"]);
  assert(t.length == 2);
  assert(t.rows[0] == ["Ä long name", "a, b", "1"]);
  auto text = t.render(6);
  assert(text.canFind("Ä lon…"));
  assert(t.renderCsv.startsWith("Name,Tags,ID\nÄ long name,\"a, b\",1\n"));

  auto kv = TextTable.keyValue(rows[0], ["name"]);
  assert(kv.rows[0][0] == "name" && kv.rows.length == 3);
}
