/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.munder;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <munder> HTML element represents a mathematical expression with an under element. 
  * It is used within the <math> element to apply an under element to a base element.
  */
class H5Munder : HtmlElement {
  mixin(HtmlTemplate!(H5Munder, "Munder", "munder", false));
}
///
unittest {
  assert(H5Munder() == "<munder></munder>");
  assert(H5Munder("Hello") == "<munder>Hello</munder>");
}
