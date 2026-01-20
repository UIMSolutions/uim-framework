/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.section;

import uim.htmls;

@safe:

class DSection : DHtmlElement {
  this() {
    super("section");
    this.selfClosing(false);
  }
}

auto Section() {
  return new DSection();
}

auto Section(string content) {
  auto element = new DSection();
  element.text(content);
  return element;
}

unittest {
  auto section = Section();
  assert(section.toString() == "<section></section>");

  auto sectionWithContent = Section("Hello");
  assert(sectionWithContent.toString() == "<section>Hello</section>");
}
