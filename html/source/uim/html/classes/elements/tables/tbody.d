module uim.html.classes.tables.tbody;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table body element
class Tbody : HtmlElement {
    this() {
        super("tbody");
    }

    static Tbody opCall() {
        return new Tbody();
    }
}
///
unittest {
    assert(Tbody() == "<tbody></tbody>");
}
