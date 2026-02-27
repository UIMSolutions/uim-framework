/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.annotation;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Annotation : HtmlElement {
  mixin(H5This!("annotation", false));

  mixin(HtmlMethods!H5Annotation);

  mixin(H5Calls!("Annotation"));
}
///
unittest {
  assert(H5Annotation() == "<annotation></annotation>");

  assert(H5Annotation("Some content") == "<annotation>Some content</annotation>");
  assert(H5Annotation(["testClass"]) == `<annotation class="testClass"></annotation>`);
  assert(H5Annotation(["a": "b"]) == `<annotation a="b"></annotation>`);

  assert(H5Annotation(["testClass"], "Some content") == `<annotation class="testClass">Some content</annotation>`);
  assert(H5Annotation(["a": "b"], "Some content") == `<annotation a="b">Some content</annotation>`);

  assert(H5Annotation(["testClass"], ["a": "b"], "Some content") == `<annotation class="testClass" a="b">Some content</annotation>`);
}
