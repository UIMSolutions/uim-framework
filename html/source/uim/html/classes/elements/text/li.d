/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.li;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML list item element
class Li : HtmlElement {
  this() {
    super("li");
  }

  /// Gets the value of the "value" attribute, which specifies the ordinal value of the list item in an ordered list.
  IHtmlAttribute value() {
    return attribute("value");
  }

  IHtmlElement value(string itemValue) {
    attribute("value", itemValue);
    return this;
  }

  static Li opCall() {
    return new Li();
  }

  static Li opCall(string content) {
    auto html = new Li();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Li() == "<li></li>");
  assert(Li("Item") == "<li>Item</li>");
}
