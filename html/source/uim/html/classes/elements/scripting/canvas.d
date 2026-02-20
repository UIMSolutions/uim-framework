/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.scripting.canvas;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <canvas> element.
  * Provides methods to set canvas attributes like height and width.
  * Example usage:
  * auto canvas = Canvas("400", "600");
  */
class H5Canvas : HtmlElement {
  mixin H5This!("canvas", false);

  /// Set height attribute
  H5Canvas height(string heightValue) {
    attribute("height", heightValue);
    return this;
  }

  /// Get height attribute
  IHtmlAttribute height() {
    return attribute("height");
  }

  // #region width
  /// Set width attribute
  H5Canvas width(string widthValue) {
    attribute("width", widthValue);
    return this;
  }

  /// Get width attribute
  IHtmlAttribute width() {
    return attribute("width");
  }
  // #endregion width

  mixin(H5Calls!("canvas"));
}
///
unittest {
  assert(H5Canvas() == `<canvas></canvas>`);
  assert(H5Canvas().height("400").width("600") == `<canvas height="400" width="600"></canvas>`);
}