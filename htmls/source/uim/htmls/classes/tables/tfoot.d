module uim.htmls.classes.tables.tfoot;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML table foot element
class DTfoot : DHtmlElement {
    this() {
        super("tfoot");
    }
}

auto Tfoot() { return new DTfoot(); }

unittest {
    auto tfoot = Tfoot();
    assert(tfoot.toString() == "<tfoot></tfoot>");
}
