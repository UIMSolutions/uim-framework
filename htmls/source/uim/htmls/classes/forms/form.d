/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.form;

import uim.htmls;

mixin(ShowModule!());

@safe:

/// HTML form element
class DForm : DHtmlElement, IHtmlForm {
    this() {
        super("form");
    }

    IHtmlAttribute name() {
        return attribute("name");
    }

    override IHtmlForm name(string nameValue) {
        attribute("name", nameValue);
        return this;
    }
    
    IHtmlForm action(string url) {
        attribute("action", url);
        return this;
    }

    IHtmlForm method(string methodValue) {
        attribute("method", methodValue);
        return this;
    }

    IHtmlForm post() {
        return method("POST");
    }

    IHtmlForm get() {
        return method("GET");
    }

    IHtmlForm enctype(string value) {
        attribute("enctype", value);
        return this;
    }
}

auto Form() { return new DForm(); }

unittest {
    auto form = Form().action("/submit").post();
    assert(form.toString().indexOf("action=\"/submit\"") > 0);
}
