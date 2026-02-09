/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.div;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <div> HTML element is a generic container for flow content that by itself does not represent anything. 
 * It can be used to group elements for styling purposes (using the class or id attributes), or because they share attribute values, such as lang. 
 * It is also commonly used as a container for JavaScript to manipulate groups of elements. 
 * When no other semantic element is appropriate, the <div> element can be used as a last resort.
 */
class Div : HtmlElement {
  this() {
    super("div");
  }


  static Div opCall() {
    return new Div();
  }

  static Div opCall(string content) {
    auto element = new Div();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Div() == "<div></div>");
  assert(Div("Hello") == "<div>Hello</div>");
}
