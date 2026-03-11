/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.aside;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents an HTML <aside> element.
  * Provides methods to set the content of the aside element.
  * Example usage:
  * <aside>This is an aside content.</aside>
  * The <aside> element is used to represent a portion of a document whose content is only indirectly related to the document's main content. It can be used for sidebars, pull quotes, or any content that is tangentially related to the main content.
  * Note: The content of the <aside> element should be relevant to the surrounding content, but it is not essential for understanding the main content of the page.
  */
class H5Aside : HtmlElement {
  mixin(HtmlTemplate!(H5Aside,"Aside", "aside", false));
}
///
unittest {
  assert(H5Aside() == `<aside></aside>`);
  assert(H5Aside(["testclass"]) == `<aside class="testclass"></aside>`);
  assert(H5Aside(["a":"b"]) == `<aside a="b"></aside>`);
  assert(H5Aside(["testclass"], ["a":"b"]) == `<aside a="b"></aside>`);

  assert(H5Aside("Hello") == `<aside>Hello</aside>`);
  assert(H5Aside(["testclass"], "Hello") == `<aside class="testclass">Hello</aside>`);
  assert(H5Aside(["a":"b"], "Hello") == `<aside a="b">Hello</aside>`);
  assert(H5Aside(["testclass"], ["a":"b"], "Hello") == `<aside class="testclass" a="b">Hello</aside>`);
}
