/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.i;

import uim.html;

mixin(ShowModule!());

@safe:

class H5I : HtmlElement {
  mixin(HtmlTemplate!(H5I, "I", "i", false));
}
///
unittest {
  assert(H5I() == "<i></i>");
  assert(H5I("Hello") == "<i>Hello</i>");
}
