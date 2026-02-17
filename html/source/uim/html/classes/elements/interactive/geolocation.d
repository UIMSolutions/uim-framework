/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.geolocation;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Geolocation : HtmlElement {
  mixin H5This!("geolocation", false);

  mixin(H5Calls!("geolocation"));
}
///
unittest {
  assert(H5Geolocation() == "<geolocation></geolocation>");
  assert(H5Geolocation("Some content") == "<geolocation>Some content</geolocation>");
}
