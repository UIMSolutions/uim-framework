/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.area;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Area : HtmlElement {
  mixin H5This!("area", false);

  mixin(H5Calls!("Area"));
}
///
unittest {
  mixin(ShowTest!"Testing H5Area");

  assert(H5Area() == "<area></area>");
  assert(H5Area("Hello") == "<area>Hello</area>");
  assert(H5Area(["test"], "Hello") == `<area class="test">Hello</area>`);
  assert(H5Area(["a":"b"], "Hello") == `<area a="b">Hello</area>`);
  assert(H5Area(["test"], ["a":"b"], "Hello") == `<area class="test" a="b">Hello</area>`);
}
