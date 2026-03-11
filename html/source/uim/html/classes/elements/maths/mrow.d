/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mrow;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mrow> HTML element represents a row of mathematical expressions. 
  * It is used within the <math> element to group together multiple elements in a horizontal layout.
  */
class H5Mrow : HtmlElement {
  mixin(HtmlTemplate!(H5Mrow, "Mrow", "mrow", false));
}
///
unittest {
  assert(H5Mrow() == "<mrow></mrow>");
  assert(H5Mrow("Hello") == "<mrow>Hello</mrow>");
}
