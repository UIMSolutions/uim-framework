
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.dd;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition description element
class Dd : HtmlElement {
    this() {
        super("dd");
    }
    static Dd opCall() {
        return new Dd();
    }
    static Dd opCall(string content) {
        auto dd = new Dd();
        dd.text(content);
        return dd;
    }
}
///
unittest {
    assert(Dd("Description") == "<dd>Description</dd>");
}
