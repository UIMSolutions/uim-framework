/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.aside;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Aside : HtmlElement {
  mixin(H5This!("aside", false));

  mixin(AttributeMethods!H5Aside);

  mixin(H5Calls!("aside"));
}
///
unittest {
  assert(H5Aside() == "<aside></aside>");
  assert(H5Aside("Hello") == "<aside>Hello</aside>");
}
