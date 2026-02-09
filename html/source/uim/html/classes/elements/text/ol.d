/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.ol;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <ol> HTML element represents an ordered list of items, where the order of the items is important. 
 * Each item in the list is typically represented by a <li> element, and the list can be styled using CSS to customize its appearance. 
 * The <ol> element can also include attributes such as "type" to specify the type of numbering for the list items, and "start" to specify the starting value for the first list item. 
 * When rendered in a web browser, the <ol> element typically displays the list items with numbers or letters to indicate their order.
 */
class Ol : HtmlElement {
  this() {
    super("ol");
  }

  /// Sets the type of numbering for the list items in an ordered list. 
  /// Valid values are "1" for numbers, "A" for uppercase letters, "a" for lowercase letters, "I" for uppercase Roman numerals, and "i" for lowercase Roman numerals.
  IHtmlElement type(string listType) {
    attribute("type", listType);
    return this;
  }

  /// Gets the value of the "type" attribute, which specifies the type of numbering for the list items in an ordered list.
  IHtmlAttribute type() {
    return attribute("type");
  }

  /// Sets the starting value for the first list item in an ordered list. This attribute is only applicable when the "type" attribute is set to "1", "A", "a", "I", or "i".
  IHtmlElement start(string startValue) {
    attribute("start", startValue);
    return this;
  }

  /// Gets the value of the "start" attribute, which specifies the starting value for the first list item in an ordered list.
  IHtmlAttribute start() {
    return attribute("start");
  }

  static Ol opCall() {
    return new Ol();
  }
}
/// Creates an ordered list with the specified content. The content can be a string or any object that can be converted to a string.
unittest {
  assert(Ol() == "<ol></ol>");
}
