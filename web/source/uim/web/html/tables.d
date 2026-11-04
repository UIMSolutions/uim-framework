/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.tables;

import uim.web;

mixin(ShowModule!());

@safe:

/// Table header cell element, e.g. th("Name") -> "<th>Name</th>"
string th(string content, string[string] attributes = null) {
  return htmlTag("th", attributes, content);
}

/// Table data cell element, e.g. td("value") -> "<td>value</td>"
string td(string content, string[string] attributes = null) {
  return htmlTag("td", attributes, content);
}

/// Table data cell spanning multiple columns
string td(string content, size_t colspan) {
  return htmlTag("td", ["colspan": colspan.to!string], content);
}

/// Table row from cell contents, e.g. tr(["a", "b"]) -> "<tr><td>a</td><td>b</td></tr>"
string tr(string[] cells, string[string] attributes = null) {
  auto row = new HtmlElement("tr").attrs(attributes);
  foreach (cell; cells) {
    row.add("td", cell);
  }
  return row.toString;
}

/// Table row of header cells, e.g. trHeader(["a", "b"]) -> "<tr><th>a</th><th>b</th></tr>"
string trHeader(string[] cells, string[string] attributes = null) {
  auto row = new HtmlElement("tr").attrs(attributes);
  foreach (cell; cells) {
    row.add("th", cell);
  }
  return row.toString;
}

/// Table caption element
string caption(string content) {
  return htmlTag("caption", content);
}

/// A complete HTML table with header row and data rows.
class HtmlTable {
  this() {
  }

  /// Sets the table caption (fluent interface)
  auto caption(string content) {
    _caption = content;
    return this;
  }

  /// Sets the header row (fluent interface)
  auto header(string[] cells) {
    _header = cells;
    return this;
  }

  /// Adds a data row (fluent interface)
  auto row(string[] cells...) {
    _rows ~= cells.dup;
    return this;
  }

  /// All data rows
  string[][] rows() const {
    return _rows.map!(row => row.dup).array;
  }

  /// Sets table attributes (fluent interface)
  auto attrs(string[string] attributes) {
    _attributes = attributes.dup;
    return this;
  }

  /// Renders the table
  override string toString() const {
    auto table = new HtmlElement("table").attrs(_attributes.dup);

    if (_caption.length > 0) {
      table.add("caption", _caption);
    }

    if (_header.length > 0) {
      auto thead = new HtmlElement("thead");
      thead.raw(trHeader(_header.dup));
      table.add(thead);
    }

    auto tbody = new HtmlElement("tbody");
    foreach (rowCells; _rows) {
      tbody.raw(tr(rowCells.dup));
    }
    table.add(tbody);

    return table.toString;
  }

  private string _caption;
  private string[] _header;
  private string[][] _rows;
  private string[string] _attributes;
}

/// Creates a table builder
HtmlTable htmlTable() {
  return new HtmlTable;
}

/// Renders a table from a header and rows in one call
string table(string[] header, string[][] rows, string[string] attributes = null) {
  auto result = new HtmlTable().header(header).attrs(attributes);
  foreach (rowCells; rows) {
    result.row(rowCells);
  }
  return result.toString;
}

///
unittest {
  assert(th("Name") == "<th>Name</th>");
  assert(th("Name", ["scope": "col"]) == `<th scope="col">Name</th>`);
  assert(td("value") == "<td>value</td>");
  assert(td("value", 2) == `<td colspan="2">value</td>`);

  assert(tr(["a", "b"]) == "<tr><td>a</td><td>b</td></tr>");
  assert(tr(["a"], ["class": "row"]) == `<tr class="row"><td>a</td></tr>`);
  assert(trHeader(["a", "b"]) == "<tr><th>a</th><th>b</th></tr>");

  assert(caption("Cap") == "<caption>Cap</caption>");

  auto tbl = new HtmlTable()
    .caption("People")
    .header(["Name", "Age"])
    .row("Alice", "30")
    .row("Bob", "25")
    .attrs(["class": "table"]);

  assert(tbl.rows.length == 2);

  string rendered = tbl.toString;
  assert(rendered.startsWith(`<table class="table">`));
  assert(rendered.canFind("<caption>People</caption>"));
  assert(rendered.canFind("<thead><tr><th>Name</th><th>Age</th></tr></thead>"));
  assert(rendered.canFind("<tbody><tr><td>Alice</td><td>30</td></tr><tr><td>Bob</td><td>25</td></tr></tbody>"));
  assert(rendered.endsWith("</table>"));

  // one-call rendering
  string quick = table(["H"], [["a"], ["b"]]);
  assert(quick == "<table><thead><tr><th>H</th></tr></thead><tbody><tr><td>a</td></tr><tr><td>b</td></tr></tbody></table>");

  // cells are escaped
  assert(tr(["<x>"]) == "<tr><td>&lt;x&gt;</td></tr>");

  // empty table renders with an empty tbody
  assert(htmlTable().toString == "<table><tbody></tbody></table>");
}
