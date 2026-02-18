/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.msup;

import uim.html;

mixin(ShowModule!());

@safe:

class H5MSup : HtmlElement {
  mixin H5This!("msup", false);

  mixin(H5Calls!("msup"));
}
///
unittest {
  assert(H5MSup() == "<msup></msup>");
  assert(H5MSup("Hello") == "<msup>Hello</msup>");
}
