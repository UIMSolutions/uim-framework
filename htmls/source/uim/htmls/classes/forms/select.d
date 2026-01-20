
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.select;

import uim.htmls;

@safe:

/// HTML select element
class DSelect : DHtmlFormElement {
    this() {
        super("select");
    }

    IHtmlAttribute name() {
        return attribute("name");
    }

    IHtmlElement name(string nameValue) {
        attribute("name", nameValue);
        return this;
    }

    IHtmlElement multiple() {
        attribute("multiple", "");
        return this;
    }

    IHtmlElement required() {
        attribute("required", "");
        return this;
    }

    IHtmlElement disabled() {
        attribute("disabled", "");
        return this;
    }

    IHtmlElement addOption(string value, string text) {
        addChild(SelectOption(value, text));
        return this;
    }
}

auto Select() { return new DSelect(); }
auto Select(string name) { auto sel = new DSelect(); sel.name(name); return sel; }

unittest {
    auto select = Select("country");
    select.addOption("us", "USA").addOption("uk", "UK");
    assert(select.toString().indexOf("select") > 0);
}
