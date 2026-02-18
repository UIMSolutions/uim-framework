/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.munderover;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Munderover : HtmlElement {
  mixin H5This!("munderover", false);

  mixin(H5Calls!("munderover"));
}
///
unittest {
  assert(H5Munderover() == "<munderover></munderover>");
  assert(H5Munderover("Hello") == "<munderover>Hello</munderover>");
}
