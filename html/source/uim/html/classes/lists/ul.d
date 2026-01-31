module uim.html.classes.lists.ul;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML unordered list element
class Ul : HtmlElement {
    this() {
        super("ul");
    }

    static Ul opCall() {
        return new Ul();
    }
}
///
unittest {
    auto ul = Ul();
    assert(ul.toString() == "<ul></ul>");
}
