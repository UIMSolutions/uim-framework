/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mi;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * The <mi> HTML element represents a mathematical identifier in a mathematical expression. 
  * It is used within the <math> element to define variables, constants, and other identifiers in mathematical notation. 
  * The <mi> element can contain text or other elements that represent the identifier, and it is typically rendered in italic type by browsers to distinguish it from regular text.
  */
class H5Mi : HtmlElement {
  mixin(H5This!("mi", false));

  mixin(AttributeMethods!H5Mi);

  mixin(H5Calls!("Mi"));
}
///
unittest {
  assert(H5Mi() == "<mi></mi>");

  assert(H5Mi("Some content") == "<mi>Some content</mi>");
  assert(H5Mi(["testClass"]) == `<mi class="testClass"></mi>`);
  assert(H5Mi(["a": "b"]) == `<mi a="b"></mi>`);

  assert(H5Mi(["testClass"], "Some content") == `<mi class="testClass">Some content</mi>`);
  assert(H5Mi(["a": "b"], "Some content") == `<mi a="b">Some content</mi>`);

  assert(H5Mi(["testClass"], ["a": "b"], "Some content") == `<mi class="testClass" a="b">Some content</mi>`);
}
