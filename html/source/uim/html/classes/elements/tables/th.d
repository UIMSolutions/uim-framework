module uim.html.classes.elements.tables.th;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table header cell element
class Th : HtmlElement {
    this() {
        super("th");
    }

    auto colspan(string value) {
        return attribute("colspan", value);
    }

    auto rowspan(string value) {
        return attribute("rowspan", value);
    }

    auto scope_(string value) {
        return attribute("scope", value);
    }

    static Th opCall() {
        return new Th();
    }

    static Th opCall(string content) {
        auto th = new Th();
        th.text(content);
        return th;
    }
}

unittest {
    assert(Th() == "<th></th>");
    assert(Th("Header") == "<th>Header</th>");
}
