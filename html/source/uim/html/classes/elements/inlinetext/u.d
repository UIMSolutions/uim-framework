/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.u;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <u> HTML element represents a span of inline text which should be rendered in a way that indicates that it has a non-textual annotation, such as a misspelling, a proper name, or an idiomatic expression. 
  * The <u> element is typically used to underline text for stylistic purposes, but it does not carry any semantic meaning on its own. 
  * It is important to note that the <u> element should not be used solely for visual styling, as it may not be accessible to all users and can be confused with other types of underlining, such as links.
  * If you want to indicate that text is misspelled or has some other type of annotation, it is recommended to use the <span> element with appropriate CSS styling instead of the <u> element.
  */
class H5U : HtmlElement {
  mixin(HtmlTemplate!(H5U, "U", "u", false));
}
///
unittest {
  assert(H5U() == "<u></u>");
  assert(H5U("Hello") == "<u>Hello</u>");
  assert(H5U(["test"], "Hello") ==  `<u class="test">Hello</u>`);
  assert(H5U(["a":"b"], "Hello") == `<u a="b">Hello</u>`);
}
