
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.lists.dd;

import uim.htmls;

@safe:

/// HTML definition description element
class DDd : DHtmlElement {
    this() {
        super("dd");
    }
}

auto Dd() { return new DDd(); }
auto Dd(string content) { auto dd = new DDd(); dd.text(content); return dd; }

unittest {
    auto dd = Dd("Description");
    assert(dd.toString() == "<dd>Description</dd>");
}
