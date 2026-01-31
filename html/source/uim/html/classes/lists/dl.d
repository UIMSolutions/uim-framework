module uim.html.classes.lists.dl;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition list element
class Dl : HtmlElement {
    this() {
        super("dl");
    }
}

auto dl() { return new Dl(); }

unittest {
    auto dl = dl();
    assert(dl.toString() == "<dl></dl>");
}
