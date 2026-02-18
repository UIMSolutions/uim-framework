/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mmultiscripts;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mmultiscripts : HtmlElement {
  mixin H5This!("mmultiscripts", false);

  mixin(H5Calls!("mmultiscripts"));
}
///
unittest {
  assert(H5Mmultiscripts() == "<mmultiscripts></mmultiscripts>");
  assert(H5Mmultiscripts("Hello") == "<mmultiscripts>Hello</mmultiscripts>");
}
