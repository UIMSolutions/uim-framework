/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mphantom;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mphantom : HtmlElement {
  mixin H5This!("mphantom", false);

  mixin(H5Calls!("mphantom"));
}
///
unittest {
  assert(H5Mphantom() == "<mphantom></mphantom>");
  assert(H5Mphantom("Hello") == "<mphantom>Hello</mphantom>");
}
