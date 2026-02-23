/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mn;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mn> HTML element represents a number in a mathematical expression. 
  * It is used within the <math> element to define numeric values.
  */
class H5Mn : HtmlElement {
  mixin(H5This!("mn", false));

  mixin(AttributeMethods!H5Mn);

  mixin(H5Calls!("Mn"));
}
///
unittest {
  assert(H5Mn() == "<mn></mn>");
  assert(H5Mn("Hello") == "<mn>Hello</mn>");
}
