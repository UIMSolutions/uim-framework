module uim.html.classes.tables.tfoot;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table foot element
class Tfoot : HtmlElement {
    this() {
        super("tfoot");
    }
    static Tfoot opCall() {
        return new Tfoot();
    }
}
///
unittest {
    auto tfoot = Tfoot();
    assert(tfoot.toString() == "<tfoot></tfoot>");
}
