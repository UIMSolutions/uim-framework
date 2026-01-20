module uim.htmls.classes.tables.td;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML table cell element
class DTd : DHtmlElement {
    this() {
        super("td");
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

auto Td() { return new DTd(); }
auto Td(string content) { auto td = new DTd(); td.text(content); return td; }

unittest {
    auto td = Td("Cell content");
    assert(td.toString() == "<td>Cell content</td>");
}
