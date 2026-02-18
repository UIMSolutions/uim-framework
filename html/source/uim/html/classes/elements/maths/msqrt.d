/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.msqrt;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Msqrt : HtmlElement {
  mixin H5This!("msqrt", false);

  mixin(H5Calls!("msqrt"));
}
///
unittest {
  assert(H5Msqrt() == "<msqrt></msqrt>");
  assert(H5Msqrt("Hello") == "<msqrt>Hello</msqrt>");
}
