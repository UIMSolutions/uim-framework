/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mspace;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mspace : HtmlElement {
  mixin H5This!("mspace", false);

  mixin(H5Calls!("mspace"));
}
///
unittest {
  assert(H5Mspace() == "<mspace></mspace>");
  assert(H5Mspace("Hello") == "<mspace>Hello</mspace>");
}
