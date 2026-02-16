/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.link;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML link element (for stylesheets, etc.)
class H5Link : HtmlElement {
    mixin H5This!("link", true);

    IHtmlElement rel(string relValue) {
        attribute("rel", relValue);
        return this;
    }

    IHtmlAttribute rel() {
        return attribute("rel");
    }

    IHtmlElement href(string url) {
        attribute("href", url);
        return this;
    }

    IHtmlAttribute href() {
        return attribute("href");
    }

    IHtmlElement type(string typeValue) {
        attribute("type", typeValue);
        return this;
    }

    IHtmlAttribute type() {
        return attribute("type");
    }

    static H5Link opCall() {
        return new H5Link();
    }

    static H5Link opCall(string href, string rel = "stylesheet") {
        auto element = new H5Link();
        element.href(href);
        element.rel(rel);
        return element;
    }
}
///
unittest {
    assert(H5Link() == "<link />");  
}
