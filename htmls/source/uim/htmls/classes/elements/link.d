/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.link;

import uim.htmls;

@safe:

/// HTML link element (for stylesheets, etc.)
class DLink : DHtmlElement {
    this() {
        super("link");
        this.selfClosing(true);
    }

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
}

auto Link() { return new DLink(); }
auto Link(string href, string rel = "stylesheet") { 
    auto element = new DLink(); 
    element.href(href);
    element.rel(rel);
    return element; 
}

unittest {
    auto link = Link("style.css");
    assert(link.toString() == `<link href="style.css" rel="stylesheet" />`);
}
