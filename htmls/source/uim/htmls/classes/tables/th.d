module uim.htmls.classes.tables.th;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// HTML table header cell element
class DTh : DHtmlElement {
    this() {
        super("th");
    }

    auto colspan(string value) {
        return attribute("colspan", value);
    }

    auto rowspan(string value) {
        return attribute("rowspan", value);
    }

    auto scope_(string value) {
        return attribute("scope", value);
    }
}

auto Th() { return new DTh(); }
auto Th(string content) { auto th = new DTh(); th.text(content); return th; }

unittest {
    auto th = Th("Header");
    assert(th.toString() == "<th>Header</th>");
}
