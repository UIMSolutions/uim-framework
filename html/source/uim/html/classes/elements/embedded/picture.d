/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.picture;

import uim.html;

mixin(ShowModule!());

@safe:


class H5Picture : HtmlElement {
  mixin H5This!("picture", false);

  mixin(H5Calls!("picture"));
}
///
unittest {
  assert(H5Picture() == "<picture></picture>");
  assert(H5Picture("Hello") == "<picture>Hello</picture>");
}
