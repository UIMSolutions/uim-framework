
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.lists.li;

import uim.htmls;

@safe:

/// HTML list item element
class DLi : DHtmlElement {
    this() {
        super("li");
    }

    IHtmlElement value(string itemValue) {
        attribute("value", itemValue);
        return this;
    }
}

auto Li() { return new DLi(); }
auto Li(string content) { auto li = new DLi(); li.text(content); return li; }

unittest {
    auto li = Li("Item");
    assert(li.toString() == "<li>Item</li>");
}
