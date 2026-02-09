/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.meta;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <meta> HTML element represents metadata that cannot be represented by other HTML elements. 
  * It is typically used to specify page description, keywords, author of the document, and other metadata. 
  * The <meta> element is placed within the <head> section of an HTML document and is not displayed on the page.
  * It can also be used to specify the character encoding for the document using the charset attribute.
  * Additionally, <meta> tags can be used for SEO purposes, providing information about the content of the page to search engines.
* 
  * Example usage:
  * <head>
  *   <meta charset="UTF-8">
  *   <meta name="description" content="A brief description of the page">
  *   <meta name="keywords" content="HTML, meta tags, SEO">
  *   <meta name="author" content="John Doe">
  * </head>
  */
class Meta : HtmlElement {
  this() {
    super("meta");
    this.selfClosing(true);
  }

  // Factory methods
  static Meta opCall() {
    return new Meta();
  }

  // Factory methods
  static Meta opCall(string content) {
    auto html = new Meta();
    html.content(content);
    return html;
  }

}
///
unittest {
  assert(Meta() == "<meta />");
}
