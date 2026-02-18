/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mi;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mi : HtmlElement {
  mixin H5This!("mi", false);

  mixin(H5Calls!("mi"));
}
///
unittest {
  assert(H5Mi() == "<mi></mi>");
  assert(H5Mi("Hello") == "<mi>Hello</mi>");
}
