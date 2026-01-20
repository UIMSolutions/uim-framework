/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.hgroup;

import uim.htmls;

@safe:

class DHgroup : DHtmlElement {
  this() {
    super("hgroup");
    this.selfClosing(false);
  }
}

auto Hgroup() {
  return new DHgroup();
}

auto Hgroup(string content) {
  auto element = new DHgroup();
  element.text(content);
  return element;
}

unittest {
  auto hgroup = Hgroup();
  assert(hgroup.toString() == "<hgroup></hgroup>");

  auto hgroupWithContent = Hgroup("Hello");
  assert(hgroupWithContent.toString() == "<hgroup>Hello</hgroup>");
}
