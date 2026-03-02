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
  mixin(HtmlTemplate!("Svg", "svg", false));
  mixin(HtmlMethods!H5Svg);
}
///
unittest {
  assert(H5Svg() == `<svg></svg>`);
  assert(H5Svg(["testclass"]) == `<svg class="testclass"></svg>`);
  assert(H5Svg(["a":"b"]) == `<svg a="b"></svg>`);

  assert(H5Svg("Hello") == `<svg>Hello</svg>`);
  assert(H5Svg(["testclass"], "Hello") == `<svg class="testclass">Hello</svg>`);
  assert(H5Svg(["a":"b"], "Hello") == `<svg a="b">Hello</svg>`);

  assert(H5Svg(["testclass"], ["a":"b"], "Hello") == `<svg class="testclass" a="b">Hello</svg>`);
}
