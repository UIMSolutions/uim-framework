/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.li;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <li> HTML element is used to represent an item in a list, and it is typically used within ordered lists (<ol>) and unordered lists (<ul>). 
 * The <li> element can contain any flow content, such as text, images, and other HTML elements, and it is usually displayed with a bullet point or a number by default, depending on the type of list it is contained within. 
 * When used within an ordered list, the <li> element represents a numbered item, while when used within an unordered list, it represents a bulleted item. 
 * The <li> element can also be used outside of lists to represent items in a menu or other types of content that require a list-like structure.
 */
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
