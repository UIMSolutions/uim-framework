/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.main;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<main>` element, which is used to denote the main content of a document. The `<main>` element is intended to contain content that is directly related to the central topic of the document, excluding any content that is repeated across documents such as sidebars, navigation links, and footers.
  * 
  * The content inside a `<main>` element should be unique to the document and should not include any content that is repeated across multiple pages (like headers, footers, or navigation bars). This helps improve accessibility and SEO by allowing assistive technologies and search engines to easily identify the primary content of the page.
  * 
  * Browser support: All major browsers support the `<main>` element.
  *
  * Examples:
  * ```html
  * <main>
  *   <h1>Main Content</h1>
  *   <p>This is the main content of the page.</p>
  * </main>
  * ```
  */
class H5Main : HtmlElement {
  mixin(HtmlTemplate!("Main", "main", false));
  mixin(HtmlMethods!H5Main);
}
///
unittest {
  assert(H5Main() == `<main></main>`);
  assert(H5Main(["testclass"]) == `<main class="testclass"></main>`);
  assert(H5Main(["a":"b"]) == `<main a="b"></main>`);

  assert(H5Main("Hello") == `<main>Hello</main>`);
  assert(H5Main(["testclass"], "Hello") == `<main class="testclass">Hello</main>`);
  assert(H5Main(["a":"b"], "Hello") == `<main a="b">Hello</main>`);

  assert(H5Main(["testclass"], ["a":"b"], "Hello") == `<main class="testclass" a="b">Hello</main>`);
}
