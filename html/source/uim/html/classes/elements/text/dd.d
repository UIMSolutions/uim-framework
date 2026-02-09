/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.dd;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <dd> HTML element provides the description, definition, or value for the preceding term (dt) in a description list (dl). 
 * It is typically used to describe a term or name defined by a <dt> element, and it can contain any flow content, including text, images, and other HTML elements. 
 * The <dd> element is usually indented from the left margin to visually distinguish it from the <dt> element, and it can be used multiple times within a single <dl> to provide multiple descriptions for a single term.
 */
class Dd : HtmlElement {
  this() {
    super("dd");
  }

  static Dd opCall() {
    return new Dd();
  }

  static Dd opCall(string content) {
    auto dd = new Dd();
    dd.text(content);
    return dd;
  }
}
///
unittest {
  assert(Dd() == "<dd></dd>");
  assert(Dd("Description") == "<dd>Description</dd>");
}
