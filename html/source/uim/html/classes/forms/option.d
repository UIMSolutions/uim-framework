/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.option;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML option element
class SelectOption : HtmlFormElement {
    this() {
        super("option");
    }

    auto value(string valueValue) {
        return attribute("value", valueValue);
    }

    auto selected() {
        return attribute("selected", "");
    }

    auto disabled() {
        return attribute("disabled", "");
    }

    static SelectOption opCall() {
        return new SelectOption();
    }

    static SelectOption opCall(string value, string text) {
        auto opt = new SelectOption();
        opt.value(value).text(text);
        return opt;
    }
}
///
unittest {
    mixin(ShowTest!"Testing SelectOption Class");

    auto option = SelectOption("1", "Option 1");
    assert(option.toString() == "<option value=\"1\">Option 1</option>");
}