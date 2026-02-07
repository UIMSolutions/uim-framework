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

  /// Set height attribute
  IHtmlElement height(string heightValue) {
    attribute("height", heightValue);
    return this;
  }

  /// Get height attribute
  IHtmlAttribute height() {
    return attribute("height");
  }

  // #region width
  /// Set width attribute
  IHtmlElement width(string widthValue) {
    attribute("width", widthValue);
    return this;
  }

  /// Get width attribute
  IHtmlAttribute width() {
    return attribute("width");
  }
  // #endregion width

  static Canvas opCall() {
    return new Canvas();
  }

  static Canvas opCall(string height, string width) {
    auto element = new Canvas();
    element.height(height);
    element.width(width);
    return element;
  }
}
///
unittest {
  assert(Canvas() == `<canvas></canvas>`);
  assert(Canvas("400", "600") == `<canvas height="400" width="600"></canvas>`);
}