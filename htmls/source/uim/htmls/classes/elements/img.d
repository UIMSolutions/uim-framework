/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.img;

import uim.htmls;

@safe:

/// HTML image element
class DImg : DHtmlElement {
    this() {
        super("img");
        this.selfClosing(true);
    }

    IHtmlElement src(string source) {
        attribute("src", source);
        return this;
    }

    IHtmlAttribute src() {
        return attribute("src");
    }

    IHtmlElement alt(string altText) {
        attribute("alt", altText);
        return this;
    }

    IHtmlAttribute alt() {
        return attribute("alt");
    }

    IHtmlElement height(string h) {
        attribute("height", h);
        return this;
    }

    IHtmlAttribute height() {
        return attribute("height");
    }

    // #region width
    // Width attribute
    IHtmlElement width(string w) {
        attribute("width", w);
        return this;
    }

    IHtmlAttribute width() {
        return attribute("width");
    }
    // #endregion width
}

auto Img() {
    return new DImg();
}

auto Img(string src, string alt = null) {
    auto element = new DImg();
    element.src(src);
    if (alt)
        element.alt(alt);
    return element;
}

unittest {
    auto img = Img("image.jpg", "Description");
    assert(img.toString() == `<img src="image.jpg" alt="Description" />`);
}
