/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.tables.col;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table cell element
class Col : HtmlElement {
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

auto col() { return new Col(); }
auto col(string content) { auto col = new Col(); col.text(content); return col; }

unittest {
    auto col = col("Cell content");
    assert(col.toString() == "<col>Cell content</col>");
}
