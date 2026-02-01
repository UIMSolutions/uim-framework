module uim.html.classes.tables.td;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table cell element
class Td : HtmlElement {
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

auto td() { return new Td(); }
auto td(string content) { auto td = new Td(); td.text(content); return td; }

unittest {
    auto td = td("Cell content");
    assert(td.toString() == "<td>Cell content</td>");
}
