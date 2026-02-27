/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.div;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents the HTML `<div>` element, which is a generic container used to group and organize content on a web page. The `<div>` element does not have any specific semantic meaning and is often used for styling purposes or as a wrapper for other elements. It can contain various types of content, including text, images, and other HTML elements.
  * 
  * Browser support: All major browsers support the `<div>` element.
  *
  * Examples:
  * ```html
  * <div>
  *   <p>This is a paragraph inside a div.</p>
  * </div>
  * ```
  */
@CssClass("container")
class H5Div : HtmlElement {
  mixin(H5Template!("Div", "div", false));
  mixin(HtmlMethods!H5Div);
}
///
unittest {
  assert(H5Div() == `<div></div>`);
  assert(H5Div(["testclass"]) == `<div class="testclass"></div>`);
  assert(H5Div(["a":"b"]) == `<div a="b"></div>`);
  assert(H5Div(["testclass"], ["a":"b"]) == `<div class="testclass" a="b"></div>`);

  assert(H5Div("Hello") == `<div>Hello</div>`);
  assert(H5Div(["testclass"], "Hello") == `<div class="testclass">Hello</div>`);
  assert(H5Div(["a":"b"], "Hello") == `<div a="b">Hello</div>`);

  assert(H5Div(["testclass"], ["a":"b"], "Hello") == `<div class="testclass" a="b">Hello</div>`);

  auto styledDiv = H5Div().container();
  assert(styledDiv == `<div class="container"></div>`);
  assert(styledDiv.isContainer());
}
