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
class Dl : DHtmlElement {
    this() {
        super("dl");
    }
}

auto Dl() { return new DDl(); }

unittest {
    auto dl = Dl();
    assert(dl.toString() == "<dl></dl>");
}
