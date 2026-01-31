/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.nav;

import uim.html;

mixin(ShowModule!());

@safe:

class Nav : HtmlElement {
  this() {
    super("nav");
    this.selfClosing(false);
  }

  static Nav opCall() {
    return new Nav();
  }
}

auto nav() {
  return new Nav();
}

auto nav(string content) {
  auto element = new Nav();
  element.text(content);
  return element;
}

unittest {
  auto nav = nav();
  assert(nav.toString() == "<nav></nav>");

  auto navWithContent = nav("Hello");
  assert(navWithContent.toString() == "<nav>Hello</nav>");
}
