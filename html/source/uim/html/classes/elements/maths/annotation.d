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
  mixin H5This!("annotation", false);

  mixin(H5Calls!("annotation"));
}
///
unittest {
  assert(H5Annotation() == "<annotation></annotation>");
  assert(H5Annotation("Hello") == "<annotation>Hello</annotation>");
}
