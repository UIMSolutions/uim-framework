/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.tables.thead;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table head element
class Thead : HtmlElement {
    this() {
        super("thead");
    }

    static Thead opCall() {
        return new Thead();
    }
}
///
unittest {
    auto thead = Thead();
    assert(thead.toString() == "<thead></thead>");
}
