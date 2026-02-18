/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mo;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mo : HtmlElement {
  mixin H5This!("mo", false);

  mixin(H5Calls!("mo"));
}
///
unittest {
  assert(H5Mo() == "<mo></mo>");
  assert(H5Mo("Hello") == "<mo>Hello</mo>");
}
