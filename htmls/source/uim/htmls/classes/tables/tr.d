module uim.htmls.classes.tables.tr;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML table row element
class DTr : DHtmlElement {
    this() {
        super("tr");
    }
}

auto Tr() { return new DTr(); }

unittest {
    auto tr = Tr();
    assert(tr.toString() == "<tr></tr>");
}
