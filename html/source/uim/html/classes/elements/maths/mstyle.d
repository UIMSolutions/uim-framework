/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mstyle;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mstyle> HTML element represents a style in a mathematical expression. 
  * It is used within the <math> element to apply style attributes to its child elements.
  */
class H5Mstyle : HtmlElement {
  mixin(H5This!("mstyle", false));

  mixin(HtmlMethods!H5Mstyle);

  mixin(H5Calls!("Mstyle"));
}
///
unittest {
  assert(H5Mstyle() == "<mstyle></mstyle>");
  assert(H5Mstyle("Hello") == "<mstyle>Hello</mstyle>");
}
