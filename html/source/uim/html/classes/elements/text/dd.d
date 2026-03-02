/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.dd;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents the HTML `<dd>` element, which is used to describe a term in a description list. The `<dd>` element is typically used in conjunction with the `<dt>` (definition term) element, which defines the term being described. The content inside a `<dd>` element provides the description or definition of the term specified by the preceding `<dt>` element.
  * 
  * Browser support: All major browsers support the `<dd>` element.
  *
  * Examples:
  * ```html
  * <dl>
  *   <dt>Term</dt>
  *   <dd>Description of the term.</dd>
  * </dl>
  * ```
  */
class H5Dd : HtmlElement {
  mixin(HtmlTemplate!("Dd", "dd", false));
  mixin(HtmlMethods!H5Dd);
}
///
unittest {
  assert(H5Dd() == `<dd></dd>`);
  assert(H5Dd(["testclass"]) == `<dd class="testclass"></dd>`);
  assert(H5Dd(["a":"b"]) == `<dd a="b"></dd>`);
  assert(H5Dd(["testclass"], ["a":"b"]) == `<dd class="testclass" a="b"></dd>`);

  assert(H5Dd("Hello") == `<dd>Hello</dd>`);
  assert(H5Dd(["testclass"], "Hello") == `<dd class="testclass">Hello</dd>`);
  assert(H5Dd(["a":"b"], "Hello") == `<dd a="b">Hello</dd>`);

  assert(H5Dd(["testclass"], ["a":"b"], "Hello") == `<dd class="testclass" a="b">Hello</dd>`);
}
