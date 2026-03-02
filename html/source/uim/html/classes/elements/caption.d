/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.caption;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents an HTML <caption> element.
  * Provides methods to set the content of the caption element.
  * Example usage:
  * auto caption = H5Caption("Table Caption");
  */
class H5Caption : HtmlElement {
  mixin(HtmlTemplate!("Caption", "caption", false));
  mixin(HtmlMethods!H5Caption);
}
///
unittest {
  assert(H5Caption() == `<caption></caption>`);
  assert(H5Caption(["testclass"]) == `<caption class="testclass"></caption>`);
  assert(H5Caption(["a":"b"]) == `<caption a="b"></caption>`);

  assert(H5Caption("Hello") == `<caption>Hello</caption>`);
  assert(H5Caption(["testclass"], "Hello") == `<caption class="testclass">Hello</caption>`);
  assert(H5Caption(["a":"b"], "Hello") == `<caption a="b">Hello</caption>`);

  assert(H5Caption(["testclass"], ["a":"b"], "Hello") == `<caption class="testclass" a="b">Hello</caption>`);
}
