/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.nav;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<nav>` element, which defines a section of a page that links to other pages or to parts within the page: a section with navigation links.
  * 
  * The `<nav>` element is intended only for major block of navigation links; typically the `<nav>` element would be used for the primary site navigation, but it could also be used for sections of navigation links that are repeated across a site, such as in a sidebar.
  * 
  * Note: Not all groups of links on a page need to be in a `<nav>` element — only sections that consist of major navigation blocks. In particular, it’s not necessary to use a `<nav>` element for a collection of internal links on a page (for example, a table of contents), unless the section has a heading and is significant enough to be listed in the document's outline.
  * 
  * The `<nav>` element is not sectioning content and does not contribute to the document outline. However, if it contains heading content, then it can be considered as an outline entry.
  * 
  * Browser support: All major browsers support the `<nav>` element.
  *
  * Examples:
  * ```html
  * <nav>
  *   <ul>
  *     <li><a href="/home">Home</a></li>
  *     <li><a href="/about">About</a></li>
  *     <li><a href="/contact">Contact</a></li>
  *   </ul>
  * </nav>
  * ```
  */
class H5Nav : HtmlElement {
  mixin(H5Template!("Nav", "nav", false));
  mixin(AttributeMethods!H5Nav);
}
///
unittest {
  assert(H5Nav() == `<nav></nav>`);
  assert(H5Nav(["testclass"]) == `<nav class="testclass"></nav>`);
  assert(H5Nav(["a":"b"]) == `<nav a="b"></nav>`);

  assert(H5Nav("Hello") == `<nav>Hello</nav>`);
  assert(H5Nav(["testclass"], "Hello") == `<nav class="testclass">Hello</nav>`);
  assert(H5Nav(["a":"b"], "Hello") == `<nav a="b">Hello</nav>`);

  assert(H5Nav(["testclass"], ["a":"b"], "Hello") == `<nav class="testclass" a="b">Hello</nav>`);
}
