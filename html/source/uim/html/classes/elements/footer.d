/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.footer;

import uim.html;

mixin(ShowModule!());

@safe:

class Footer : HtmlElement {
  this() {
    super("footer");
    this.selfClosing(false);
  }
}

auto footer() {
  return new Footer();
}

auto footer(string content) {
  auto element = new Footer();
  element.text(content);
  return element;
}

unittest {
  auto footer = footer();
  assert(footer.toString() == "<footer></footer>");

  auto footerWithContent = footer("Hello");
  assert(footerWithContent.toString() == "<footer>Hello</footer>");
}
