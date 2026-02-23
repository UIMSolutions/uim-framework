/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.iframe;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <iframe> HTML element is used to embed another HTML document within the current document. 
 * It creates a nested browsing context, allowing you to display content from another source, such as a different web page or an external resource, within a specified area of the parent page. 
 * The <iframe> element typically requires the "src" attribute to specify the URL of the content being embedded, and it may also include attributes like "width" and "height" to define the dimensions of the embedded content. 
 * When rendered in a web browser, the <iframe> element displays the embedded content directly within the page, allowing users to interact with it as if it were part of the parent document.
 *
 * Example usage:
 * ```html
 * <iframe src="https://www.example.com" width="600" height="400"></iframe>
 * ```
 * This would embed the web page located at "https://www.example.com" with a specified width of 600 pixels and height of 400 pixels.
 */
class H5Iframe : HtmlElement {
  mixin(H5This!("iframe", false));

  /**
      * Sets the URL of the content being embedded in the <iframe> element. This attribute is required for the <iframe> element to function properly, as it specifies the source of the content to be displayed.
      *
      * Example usage:
      * ```html
      * <iframe src="https://www.example.com"></iframe>
      * ```
      * This would embed the web page located at "https://www.example.com" within the iframe.
      */
  H5Iframe src(string url) {
    attribute("src", url);
    return this;
  }

  /**
      * Gets the value of the "src" attribute, which specifies the URL of the content being embedded in the <iframe> element.
      *
      * Example usage:
      * ```html
      * <iframe src="https://www.example.com"></iframe>
      * ```
      * This would embed the web page located at "https://www.example.com" within the iframe, and calling the src() method would return "https://www.example.com".
      */
  IHtmlAttribute src() {
    return attribute("src");
  }

  H5Iframe width(string width) {
    attribute("width", width);
    return this;
  }

  IHtmlAttribute width() {
    return attribute("width");
  }

  H5Iframe height(string height) {
    attribute("height", height);
    return this;
  }

  IHtmlAttribute height() {
    return attribute("height");
  }

  H5Iframe title(string title) {
    attribute("title", title);
    return this;
  }

  IHtmlAttribute title() {
    return attribute("title");
  }

  H5Iframe allowfullscreen(bool isAllowed) {
    if (isAllowed) {
      attribute("allowfullscreen", "allowfullscreen");
    } else {
      removeAttribute("allowfullscreen");
    }
    return this;
  }

  IHtmlAttribute allowfullscreen() {
    return attribute("allowfullscreen");
  }

  H5Iframe loading(string loading) {
    attribute("loading", loading);
    return this;
  }

  IHtmlAttribute loading() {
    return attribute("loading");
  }



  mixin(H5Calls!("iframe"));
}
///
unittest {
  assert(H5Iframe() == "<iframe></iframe>");
  assert(H5Iframe("Hello") == "<iframe>Hello</iframe>");
  assert(H5Iframe()
      .src("https://www.example.com") == "<iframe src=\"https://www.example.com\"></iframe>");
  assert(H5Iframe().width("600") == "<iframe width=\"600\"></iframe>");
  assert(H5Iframe().height("400") == "<iframe height=\"400\"></iframe>");
  assert(H5Iframe().allowfullscreen(true) == "<iframe allowfullscreen=\"allowfullscreen\"></iframe>");
  assert(H5Iframe().allowfullscreen(false) == "<iframe></iframe>");
  assert(H5Iframe().loading("lazy") == "<iframe loading=\"lazy\"></iframe>");
  assert(H5Iframe().title("Example Iframe") == "<iframe title=\"Example Iframe\"></iframe>");
}
