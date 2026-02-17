/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.footer;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<footer>` element, which defines a footer for a document or a section. A footer typically contains information about the author, copyright information, links to related documents, or other relevant information.
  * 
  * The `<footer>` element is used to group together related content at the end of a document or a section. It can be used within the `<body>` element to define a footer for the entire page, or within a `<section>`, `<article>`, or other container elements to define a footer for that specific section.
  * 
  * Browser support: All major browsers support the `<footer>` element.
  *
  * Examples:
  * ```html
  * <footer>
  *   <p>&copy; 2024 My Website</p>
  * </footer>
  * ```
  */
class Footer : HtmlElement {
  mixin H5This!("footer", false);

  static Footer opCall() {
    return new Footer();
  }

  static Footer opCall(string content) {
    auto element = new Footer();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Footer() == "<footer></footer>");
  assert(Footer("Hello") == "<footer>Hello</footer>");
}
