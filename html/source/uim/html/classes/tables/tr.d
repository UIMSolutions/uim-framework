module uim.html.classes.tables.tr;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table row element
class Tr : HtmlElement {
    this() {
        super("tr");
    }
}

auto tr() { return new Tr(); }

unittest {
    auto tr = tr();
    assert(tr.toString() == "<tr></tr>");
}
