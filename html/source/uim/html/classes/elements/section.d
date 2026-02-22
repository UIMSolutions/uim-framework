/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.section;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<section>` element, which defines a section in a document. A section is a thematic grouping of content, typically with a heading.
  * 
  * The `<section>` element is used to group together related content, such as a chapter, a tabbed section, or a thematic grouping of content. It is often used in conjunction with headings (`<h1>` to `<h6>`) to provide structure and organization to the content.
  * 
  * Browser support: All major browsers support the `<section>` element.
  *
  * Examples:
  * ```html
  * <section>
  *   <h2>Introduction</h2>
  *   <p>This is the introduction section.</p>
  * </section>
  * ```
  */
class H5Section : HtmlElement {
  mixin H5This!("section", false);

  mixin(StringAttributeMethods!H5Section);

  mixin(H5Calls!("section"));
}
///
unittest {
  assert(H5Section() == "<section></section>");
  assert(H5Section("Hello") == "<section>Hello</section>");
  assert(H5Section(["test"], "Hello") == `<section class="test">Hello</section>`);
  assert(H5Section(["a": "b"], "Hello") == `<section a="b">Hello</section>`);
  assert(H5Section(["test"], ["a": "b"], "Hello") == `<section class="test" a="b">Hello</section>`);
}
