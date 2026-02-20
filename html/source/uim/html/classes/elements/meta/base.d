/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.base;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * HTML base element
  * The <base> element specifies the base URL and/or target for all relative URLs in a document.
  * It must be included inside the <head> element and can only appear once.
  * 
  * Example usage:
  * 
  * <head>
  *   <base href="https://example.com/" target="_blank">
  * </head>
  */
class H5Base : HtmlElement {
  mixin H5This!("base", true);

  H5Base href(string value) {
    attribute("href", value);
    return this;
  }

  IHtmlAttribute href() {
    return attribute("href");
  }

  // #region target
  // Valid values for target attribute
  // _self, _blank, _parent, _top, framename
  H5Base target(string value) {
    attribute("target", value);
    return this;
  }

  IHtmlAttribute target() {
    return attribute("target");
  }
  // #endregion target

  mixin(H5Calls!("base"));
}
///
unittest {
  assert(H5Base() == "<base>");
  assert(H5Base().href("https://example.com") == "<base href=\"https://example.com\">");
  assert(H5Base().target("_blank") == "<base target=\"_blank\">");
  assert(H5Base().target("_blank").target() == "_blank");
}
