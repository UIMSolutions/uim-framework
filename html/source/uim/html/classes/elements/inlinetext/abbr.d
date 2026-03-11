/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.abbr;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <abbr> element.
  * Provides methods to set the title attribute and content of the abbreviation.
  * Example usage:
  * auto abbr = Abbr("HTML").title("HyperText Markup Language");
  *
  * Note: The <abbr> element is used to represent an abbreviation or acronym, providing a full description in the title attribute.
*/
class H5Abbr : HtmlElement {
  mixin(HtmlTemplate!(H5Abbr, "Abbr", "abbr", false));

  /// Sets the title attribute of the abbreviation.
  H5Abbr title(string val) {
    attribute("title", val);
    return this;
  }

  IHtmlAttribute title() {
    return attribute("title");
  }
}
///
unittest {
  assert(H5Abbr() == "<abbr></abbr>");
  assert(H5Abbr("Hello") == "<abbr>Hello</abbr>");
}
