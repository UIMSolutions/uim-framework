/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.select;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML select element
class Select : DHtmlFormElement {
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

auto select() { return new Select(); }
auto select(string name) { auto sel = new Select(); sel.name(name); return sel; }

unittest {
    auto sel = select("mySelect").multiple().addOption("1", "Option 1").addOption("2", "Option 2");
    assert(sel.toString().indexOf("select") > 0);
}   