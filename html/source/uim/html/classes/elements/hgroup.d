/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.hgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class Hgroup : HtmlElement {
  this() {
    super("hgroup");
    this.selfClosing(false);
  }
}

auto hgroup() {
  return new Hgroup();
}

auto hgroup(string content) {
  auto element = new Hgroup();
  element.text(content);
  return element;
}

unittest {
  auto hgroup = hgroup();
  assert(hgroup.toString() == "<hgroup></hgroup>");

  auto hgroupWithContent = hgroup("Hello");
  assert(hgroupWithContent.toString() == "<hgroup>Hello</hgroup>");
}
