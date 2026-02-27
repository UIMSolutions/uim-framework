/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.munderover;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <munderover> HTML element represents a mathematical expression with both an under and over element. 
  * It is used within the <math> element to apply both under and over elements to a base element.
  */
class H5Munderover : HtmlElement {
  mixin(H5This!("munderover", false));

  mixin(HtmlMethods!H5Munderover);

  mixin(H5Calls!("Munderover"));
}
///
unittest {
  assert(H5Munderover() == "<munderover></munderover>");
  assert(H5Munderover("Hello") == "<munderover>Hello</munderover>");
}
