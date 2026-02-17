/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.embed;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Embed : HtmlElement {
  mixin H5This!("embed", false);

  mixin(H5Calls!("embed"));
}
///
unittest {
  assert(H5Embed() == "<embed></embed>");
  assert(H5Embed("Hello") == "<embed>Hello</embed>");
}
