/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.img;

import uim.html;

mixin(ShowModule!());

@safe:

/**
    * The <img> HTML element embeds an image into the document. 
    * It is a self-closing tag and does not require a closing tag. 
    * The <img> element has several attributes, including:
    * - src: Specifies the URL of the image to be displayed.
    * - alt: Provides alternative text for the image, which is displayed if the image cannot be loaded or for screen readers.
    * - width: Specifies the width of the image in pixels or as a percentage of the containing element.
    * - height: Specifies the height of the image in pixels or as a percentage of the containing element.
    *
    * Example usage:
    * ```html
    * <img src="image.jpg" alt="A description of the image" width="500" height="300">
    * ```
    */
class H5Img : HtmlElement {
    mixin H5This!("img", true);

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

    static H5Img opCall() {
        return new H5Img();
    }

    static H5Img opCall(string src, string alt = null) {
        auto element = new H5Img();
        element.src(src);
        if (alt)
            element.alt(alt);
        return element;
    }
}
///
unittest {
    assert(H5Img() == `<img />`);
    assert(H5Img("image.png", "An image") == `<img alt="An image" src="image.png" />`);
}