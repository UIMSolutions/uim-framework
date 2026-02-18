/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mrow;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mrow : HtmlElement {
  mixin H5This!("mrow", false);

  mixin(H5Calls!("mrow"));
}
///
unittest {
  assert(H5Mrow() == "<mrow></mrow>");
  assert(H5MMrow("Hello") == "<mrow>Hello</mrow>");
}
