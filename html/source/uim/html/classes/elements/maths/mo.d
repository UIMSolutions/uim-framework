/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mo;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mo> HTML element represents an operator in a mathematical expression. 
  * It is used within the <math> element to define mathematical operators such as addition (+), subtraction (-), multiplication (×), division (÷), and more complex operators. 
  * The <mo> element can also be used to represent relational operators, logical operators, and other symbols that are part of mathematical notation.
  */
class H5Mo : HtmlElement {
  mixin(HtmlTemplate!(H5Mo, "Mo", "mo", false));
}
///
unittest {
  assert(H5Mo() == "<mo></mo>");
  assert(H5Mo("Hello") == "<mo>Hello</mo>");
}
