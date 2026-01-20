module uim.htmls.classes.tables.tbody;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML table body element
class DTbody : DHtmlElement {
    this() {
        super("tbody");
    }
}

auto Tbody() { return new DTbody(); }

unittest {
    auto tbody = Tbody();
    assert(tbody.toString() == "<tbody></tbody>");
}
