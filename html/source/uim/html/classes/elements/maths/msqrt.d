/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.msqrt;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <msqrt> HTML element represents a square root in a mathematical expression. 
  * It is used within the <math> element to define the square root of a number or expression.
  */
class H5Msqrt : HtmlElement {
  mixin(H5This!("msqrt", false));

  mixin(HtmlMethods!H5Msqrt);

  mixin(H5Calls!("Msqrt"));
}
///
unittest {
  assert(H5Msqrt() == "<msqrt></msqrt>");
  assert(H5Msqrt("Hello") == "<msqrt>Hello</msqrt>");
}
