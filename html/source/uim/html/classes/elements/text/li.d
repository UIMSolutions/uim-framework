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
class H5Li : HtmlElement {
  mixin H5This!("li", false);

  /// Gets the value of the "value" attribute, which specifies the ordinal value of the list item in an ordered list.
  H5Li value() {
    attribute("value");
    return this;
  }

  H5Li value(string itemValue) {
    attribute("value", itemValue);
    return this;
  }

  mixin(H5Calls!("li"));
}
///
unittest {
  assert(H5Li() == "<li></li>");
  assert(H5Li("Item") == "<li>Item</li>");
}
