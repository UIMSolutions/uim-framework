/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.article;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Article : HtmlElement {
  mixin H5This!("article", false);

  mixin(H5AttributeMethods!H5Article);

  mixin(H5Calls!("article"));
}
///
unittest {
  assert(H5Article() == "<article></article>");
  assert(H5Article("Hello") == "<article>Hello</article>");
}
