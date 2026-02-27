/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mtr;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mtr> HTML element represents a row in a mathematical table. 
  * It is used within the <mtable> element to define a row of cells in a mathematical table.
  */
class H5Mtr : HtmlElement {
  mixin(H5This!("mtr", false));

  mixin(HtmlMethods!H5Mtr);

  mixin(H5Calls!("Mtr"));
}
///
unittest {
  assert(H5Mtr() == "<mtr></mtr>");
  assert(H5Mtr("Hello") == "<mtr>Hello</mtr>");
}
