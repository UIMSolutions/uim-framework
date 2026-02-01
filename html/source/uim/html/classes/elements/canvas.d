/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.canvas;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML canvas element
class Canvas : HtmlElement {
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

auto canvas() {
  return new Canvas();
}

auto canvas(string height, string width) {
  auto element = new Canvas();
  element.height(height);
  element.width(width);
  return element;
}

