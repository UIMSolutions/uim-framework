/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.bdi;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <bdi> HTML element represents a span of text that is isolated from its surrounding text in terms of bidirectional text formatting. 
 * It allows for the correct display of text that may have a different directionality than the surrounding text, such as when embedding a right-to-left language within a left-to-right context, or vice versa. 
 * The <bdi> element does not affect the directionality of the text it contains, but it prevents the surrounding text from affecting the directionality of the contained text.
 */
class H5Bdi : HtmlElement {
  mixin(HtmlTemplate!(H5Bdi, "Bdi", "bdi", false));
}
///
unittest {
  assert(H5Bdi() == "<bdi></bdi>");
  assert(H5Bdi(["testClass"]) == `<bdi class="testClass"></bdi>`);
  assert(H5Bdi(["a":"b"]) == `<bdi a="b"></bdi>`);
  assert(H5Bdi(["testClass"], ["a":"b"]) == `<bdi class="testClass" a="b"></bdi>`);

  assert(H5Bdi("Hello") == "<bdi>Hello</bdi>");
  assert(H5Bdi(["testClass"], "Hello") == `<bdi class="testClass">Hello</bdi>`);
  assert(H5Bdi(["a":"b"], "Hello") == `<bdi a="b">Hello</bdi>`);
  assert(H5Bdi(["testClass"], ["a":"b"], "Hello") == `<bdi class="testClass" a="b">Hello</bdi>`);
}
