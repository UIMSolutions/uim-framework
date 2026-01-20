module uim.htmls.classes.tables.col;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML table cell element
class DCol : DHtmlElement {
    this() {
        super("col");
    }

    IHtmlElement colspan(string value) {
        attribute("colspan", value);
        return this;
    }

    IHtmlElement rowspan(string value) {
        attribute("rowspan", value);
        return this;
    }
}

auto Col() { return new DCol(); }
auto Col(string content) { auto col = new DCol(); col.text(content); return col; }

unittest {
    auto col = Col("Cell content");
    assert(col.toString() == "<col>Cell content</col>");
}
