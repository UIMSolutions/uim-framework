module uim.htmls.classes.lists.ul;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML unordered list element
class DUl : DHtmlElement {
    this() {
        super("ul");
    }
}

auto Ul() { return new DUl(); }

unittest {
    auto ul = Ul();
    assert(ul.toString() == "<ul></ul>");
}
