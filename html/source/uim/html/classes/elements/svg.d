/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.svg;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Svg : HtmlElement {
  mixin H5This!("svg", false);

  mixin(H5Calls!("Svg"));
}
///
unittest {
  assert(H5Svg() == "<svg></svg>");
  assert(H5Svg("Hello") == "<svg>Hello</svg>");
  assert(H5Svg(["id": "my-svg"]) == "<svg id=\"my-svg\"></svg>");
  assert(H5Svg(["id": "my-svg"], "Hello") == "<svg id=\"my-svg\">Hello</svg>");
}
