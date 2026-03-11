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
  mixin(HtmlTemplate!(H5Geolocation, "Geolocation", "geolocation", false));
}
///
unittest {
  assert(H5Geolocation() == "<geolocation></geolocation>");

  assert(H5Geolocation("Some content") == "<geolocation>Some content</geolocation>");
  assert(H5Geolocation(["testClass"]) == `<geolocation class="testClass"></geolocation>`);
  assert(H5Geolocation(["a":"b"]) == `<geolocation a="b"></geolocation>`);

  assert(H5Geolocation(["testClass"], "Some content") == `<geolocation class="testClass">Some content</geolocation>`);
  assert(H5Geolocation(["a":"b"], "Some content") == `<geolocation a="b">Some content</geolocation>`);

  assert(H5Geolocation(["testClass"], ["a":"b"], "Some content") == `<geolocation class="testClass" a="b">Some content</geolocation>`);
}
