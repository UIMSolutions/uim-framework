module uim.html.classes.tables.thead;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.html;

@safe:

/// HTML table head element
class DThead : DHtmlElement {
    this() {
        super("thead");
    }
}

auto Thead() { return new DThead(); }

unittest {
    auto thead = Thead();
    assert(thead.toString() == "<thead></thead>");
}
