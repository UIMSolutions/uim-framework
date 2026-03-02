/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.search;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<search>` element, which defines a section of a page that is intended for searching or filtering content.
  * 
  * The `<search>` element is used to group together search-related elements, such as a search input field and a submit button. It provides semantic meaning to the content within it, indicating that it is related to searching or filtering.
  * 
  * Browser support: As of now, the `<search>` element is not widely supported in all browsers. It is recommended to use it with caution and provide fallback options for browsers that do not support it.
  *
  * Examples:
  * ```html
  * <search>
  *   <input type="text" placeholder="Search...">
  *   <button type="submit">Search</button>
  * </search>
  * ```
  */
class H5Search : HtmlElement {
  mixin(HtmlTemplate!("Search", "search", false));
  mixin(HtmlMethods!H5Search);
}
///
unittest {
  assert(H5Search() == `<search></search>`);
  assert(H5Search(["testclass"]) == `<search class="testclass"></search>`);
  assert(H5Search(["a":"b"]) == `<search a="b"></search>`);

  assert(H5Search("Hello") == `<search>Hello</search>`);
  assert(H5Search(["testclass"], "Hello") == `<search class="testclass">Hello</search>`);
  assert(H5Search(["a":"b"], "Hello") == `<search a="b">Hello</search>`);

  assert(H5Search(["testclass"], ["a":"b"], "Hello") == `<search class="testclass" a="b">Hello</search>`);
}
