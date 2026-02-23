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
class H5Footer : HtmlElement {
  mixin(H5This!("footer", false));

  mixin(AttributeMethods!H5Footer);

  mixin(H5Calls!("footer"));
}
///
unittest {
  assert(H5Footer() == "<footer></footer>");
  assert(H5Footer("Hello") == "<footer>Hello</footer>");
  assert(H5Footer(["testclass"]) == "<footer class=\"testclass\"></footer>");
  assert(H5Footer(["a":"b"]) == `<footer a="b"></footer>`);
}
