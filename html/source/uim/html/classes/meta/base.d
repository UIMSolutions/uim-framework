/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.meta.base;

import uim.html;

@safe:

/// HTML base element
class DBase : DHtmlElement {
  this() {
    super("base");
    this.selfClosing(true);
  }

  IHtmlElement href(string h) {
    attribute("href", h);
    return this;
  }

  IHtmlAttribute href() {
    return attribute("href");
  }

  // #region target
  // Valid values for target attribute
  // _self, _blank, _parent, _top, framename
  IHtmlElement target(string value) {
    attribute("target", value);
    return this;
  }

  IHtmlAttribute target() {
    return attribute("target");
  }
  // #endregion target
}

auto Base() {
  return new DBase();
}

unittest {
  auto base = Base("https://example.com", "Example");
  assert(base.toString() == `<base cite="https://example.com">Example</base>`);
}
