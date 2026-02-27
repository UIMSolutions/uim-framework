/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mfrac;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mfrac : HtmlElement {
  mixin(H5This!("mfrac", false));

  mixin(AttributeMethods!H5Mfrac);

  mixin(H5Calls!("Mfrac"));
}
///
unittest {
  assert(H5Mfrac() == "<mfrac></mfrac>");

  assert(H5Mfrac("Some content") == "<mfrac>Some content</mfrac>");
  assert(H5Mfrac(["testClass"]) == `<mfrac class="testClass"></mfrac>`);
  assert(H5Mfrac(["a": "b"]) == `<mfrac a="b"></mfrac>`);

  assert(H5Mfrac(["testClass"], "Some content") == `<mfrac class="testClass">Some content</mfrac>`);
  assert(H5Mfrac(["a": "b"], "Some content") == `<mfrac a="b">Some content</mfrac>`);

  assert(H5Mfrac(["testClass"], ["a": "b"], "Some content") == `<mfrac class="testClass" a="b">Some content</mfrac>`);  
}
