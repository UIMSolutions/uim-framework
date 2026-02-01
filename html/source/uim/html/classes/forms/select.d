/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.select;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML select element
class Select : FormElement {
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

    static Select opCall() {
        return new Select();
    }

    static Select opCall(string name) {
        auto sel = new Select();
        sel.name(name);
        return sel;
    }
}

unittest {
    // TODO: auto sel = select("mySelect").multiple().addOption("1", "Option 1").addOption("2", "Option 2");
    // assert(sel.toString().indexOf("select") > 0);
}
