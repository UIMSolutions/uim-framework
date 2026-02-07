/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.hr;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML horizontal rule element
class Hr : HtmlElement {
    this() {
        super("hr");
        this.selfClosing(true);
    }

    static Hr opCall() {
        return new Hr();
    }
}
///
unittest {
    assert(Hr() == "<hr />");
}
