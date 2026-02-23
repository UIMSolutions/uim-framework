/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.hgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Hgroup : HtmlElement {
  mixin(H5This!("hgroup", false));

  mixin(H5Calls!("Hgroup"));
}
///
unittest {
  assert(H5Hgroup() == "<hgroup></hgroup>");
  assert(H5Hgroup("Hello") == "<hgroup>Hello</hgroup>");
}
