/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.dt;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <dt> HTML element is used to specify a term in a description list (dl), and it is typically followed by one or more <dd> elements that provide the corresponding description for that term. 
 * The <dt> element can contain any inline content, such as text, images, and other HTML elements, but it cannot contain block-level elements. 
 * The <dt> element is usually displayed in bold font by default, and it is often indented from the left margin to visually distinguish it from the <dd> elements that follow it. 
 */
class H5Dt : HtmlElement {
  mixin(H5Template!("Dt", "dt", false));
  mixin(AttributeMethods!H5Dt);
}
///
unittest {
  assert(H5Dt() == `<dt></dt>`);
  assert(H5Dt(["testclass"]) == `<dt class="testclass"></dt>`);
  assert(H5Dt(["a":"b"]) == `<dt a="b"></dt>`);

  assert(H5Dt("Hello") == `<dt>Hello</dt>`);
  assert(H5Dt(["testclass"], "Hello") == `<dt class="testclass">Hello</dt>`);
  assert(H5Dt(["a":"b"], "Hello") == `<dt a="b">Hello</dt>`);

  assert(H5Dt(["testclass"], ["a":"b"], "Hello") == `<dt class="testclass" a="b">Hello</dt>`);
}
