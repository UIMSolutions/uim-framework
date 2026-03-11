/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.hgroup;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents the HTML <hgroup> element, which is used to group a set of <h1> to <h6> elements when a heading has multiple levels. The <hgroup> element allows you to semantically group related headings together, indicating that they belong to the same section or topic. This can be useful for accessibility and SEO purposes, as it helps search engines and assistive technologies understand the structure of your content.
  * 
  * Browser support: All major browsers support the <hgroup> element.
  *
  * Examples:
  * ```html
  * <hgroup>
  *   <h1>Main Heading</h1>
  *   <h2>Subheading</h2>
  * </hgroup>
  * ```
  */
class H5Hgroup : HtmlElement {
  mixin(HtmlTemplate!(H5Hgroup, "Hgroup", "hgroup", false));
  mixin(HtmlMethods!H5Hgroup);
}
///
unittest {
  assert(H5Hgroup() == `<hgroup></hgroup>`);
  assert(H5Hgroup(["testclass"]) == `<hgroup class="testclass"></hgroup>`);
  assert(H5Hgroup(["a":"b"]) == `<hgroup a="b"></hgroup>`);

  assert(H5Hgroup("Hello") == `<hgroup>Hello</hgroup>`);
  assert(H5Hgroup(["testclass"], "Hello") == `<hgroup class="testclass">Hello</hgroup>`);
  assert(H5Hgroup(["a":"b"], "Hello") == `<hgroup a="b">Hello</hgroup>`);

  assert(H5Hgroup(["testclass"], ["a":"b"], "Hello") == `<hgroup class="testclass" a="b">Hello</hgroup>`);
}
