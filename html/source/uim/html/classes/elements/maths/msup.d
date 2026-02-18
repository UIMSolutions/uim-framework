/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.msup;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Msup : HtmlElement {
  mixin H5This!("msup", false);

  mixin(H5Calls!("msup"));
}
///
unittest {
  assert(H5MMsup() == "<msup></msup>");
  assert(H5MMsup("Hello") == "<msup>Hello</msup>");
}
