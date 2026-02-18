/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.msub;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Msub : HtmlElement {
  mixin H5This!("msub", false);

  mixin(H5Calls!("msub"));
}
///
unittest {
  assert(H5Msub() == "<msub></msub>");
  assert(H5Msub("Hello") == "<msub>Hello</msub>");
}
