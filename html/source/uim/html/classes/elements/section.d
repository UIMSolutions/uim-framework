/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.section;

import uim.html;

mixin(ShowModule!());

@safe:

class Section : HtmlElement {
  this() {
    super("section");
    this.selfClosing(false);
  }
}

auto section() {
  return new Section();
}

auto section(string content) {
  auto element = new Section();
  element.text(content);
  return element;
}

unittest {
  auto section = section();
  assert(section.toString() == "<section></section>");

  auto sectionWithContent = section("Hello");
  assert(sectionWithContent.toString() == "<section>Hello</section>");
}
