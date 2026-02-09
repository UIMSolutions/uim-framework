/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.style;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML style element
class Style : HtmlElement {
  this() {
    super("style");
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
  static Style opCall() {
    return new Style();
  }
}
