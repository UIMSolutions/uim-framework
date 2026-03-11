/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.header;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<header>` element, which defines a header for a document or a section. The `<header>` element typically contains introductory content or navigational links.
  * 
  * The `<header>` element is used to group together a set of introductory or navigational content, such as a logo, a heading, and a navigation menu. It is often placed at the top of a page or section to provide context and navigation options for users.
  * 
  * Browser support: All major browsers support the `<header>` element.
  *
  * Examples:
  * ```html
  * <header>
  *   <h1>My Website</h1>
  *   <nav>
  *     <ul>
  *       <li><a href="#home">Home</a></li>
  *       <li><a href="#about">About</a></li>
  *       <li><a href="#contact">Contact</a></li>
  *     </ul>
  *   </nav>
  * </header>
  * ```
  */
class H5Header : HtmlElement {
  mixin(HtmlTemplate!(H5Header, "Header", "header", false));
  mixin(HtmlMethods!H5Header);
}
///
unittest {
  assert(H5Header() == `<header></header>`);
  assert(H5Header(["testclass"]) == `<header class="testclass"></header>`);
  assert(H5Header(["a": "b"]) == `<header a="b"></header>`);

  assert(H5Header("Hello") == `<header>Hello</header>`);
  assert(H5Header(["testclass"], "Hello") == `<header class="testclass">Hello</header>`);
  assert(H5Header(["a": "b"], "Hello") == `<header a="b">Hello</header>`);

  assert(H5Header(["testclass"], ["a": "b"], "Hello") == `<header class="testclass" a="b">Hello</header>`);
}
