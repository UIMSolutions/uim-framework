/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mtr;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mtr : HtmlElement {
  mixin H5This!("mtr", false);

  mixin(H5Calls!("mtr"));
}
///
unittest {
  assert(H5Mtr() == "<mtr></mtr>");
  assert(H5Mtr("Hello") == "<mtr>Hello</mtr>");
}
