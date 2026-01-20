/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.canvas;

import uim.htmls;

@safe:

/// HTML canvas element
class DCanvas : DHtmlElement {
  this() {
    super("canvas");
  }

  IHtmlElement height(string h) {
    attribute("height", h);
    return this;
  }

  IHtmlAttribute height() {
    return attribute("height");
  }

  // #region width
  // Width attribute
  IHtmlElement width(string w) {
    attribute("width", w);
    return this;
  }

  IHtmlAttribute width() {
    return attribute("width");
  }
  // #endregion width
}

auto Canvas() {
  return new DCanvas();
}

auto Canvas(string height, string width) {
  auto element = new DCanvas();
  element.height(height);
  element.width(width);
  return element;
}

unittest {
  auto canvas = Canvas("https://example.com", "Example");
  assert(canvas.toString() == `<canvas cite="https://example.com">Example</canvas>`);
}
