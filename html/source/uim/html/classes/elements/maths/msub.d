/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.msub;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <msub> HTML element represents a subscript in a mathematical expression. 
  * It is used within the <math> element to apply a subscript to a base element.
  */
class H5Msub : HtmlElement {
  mixin(H5This!("msub", false));

  mixin(AttributeMethods!H5Msub);

  mixin(H5Calls!("Msub"));
}
///
unittest {
  assert(H5Msub() == "<msub></msub>");
  assert(H5Msub("Hello") == "<msub>Hello</msub>");
}
