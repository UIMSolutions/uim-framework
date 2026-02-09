/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.thead;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table head element
class Thead : HtmlElement {
    this() {
        super("thead");
    }

    static Thead opCall() {
        return new Thead();
    }
}
///
unittest {
    assert(Thead() == "<thead></thead>");
}
