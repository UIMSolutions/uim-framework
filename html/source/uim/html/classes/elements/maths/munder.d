/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.munder;

import uim.html;

mixin(ShowMunderdule!());

@safe:

class H5Munder : HtmlElement {
  mixin H5This!("munder", false);

  mixin(H5Calls!("munder"));
}
///
unittest {
  assert(H5Munder() == "<munder></munder>");
  assert(H5Munder("Hello") == "<munder>Hello</munder>");
}
