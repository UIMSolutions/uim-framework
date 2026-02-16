/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.nav;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Nav : HtmlElement {
  mixin H5This!("nav", false);

  static H5Nav opCall() {
    return new H5Nav();
  }

  static H5Nav opCall(string content) {
    auto element = new H5Nav();
    element.content(content);
    return element;
  }
}

unittest {
  assert(H5Nav() == "<nav></nav>");
  assert(H5Nav("Hello") == "<nav>Hello</nav>");
}
