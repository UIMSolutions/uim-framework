/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.tables.table;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table element
class Table : HtmlElement {
    this() {
        super("table");
    }

    IHtmlElement border(string borderValue) {
        attribute("border", borderValue);
        return this;
    }

    IHtmlElement cellspacing(string value) {
        attribute("cellspacing", value);
        return this;
    }

    IHtmlElement cellpadding(string value) {
        attribute("cellpadding", value);
        return this;
    }

    static Table opCall() {
        return new Table();
    }
}
///
unittest {
    mixin(ShowTest!"Testing Table Class");

    auto table = Table();
    assert(table.toString() == "<table></table>");
}
