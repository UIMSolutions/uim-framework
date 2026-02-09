/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.dt;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <dt> HTML element is used to specify a term in a description list (dl), and it is typically followed by one or more <dd> elements that provide the corresponding description for that term. 
 * The <dt> element can contain any inline content, such as text, images, and other HTML elements, but it cannot contain block-level elements. 
 * The <dt> element is usually displayed in bold font by default, and it is often indented from the left margin to visually distinguish it from the <dd> elements that follow it. 
 */
class Dt : HtmlElement {
  this() {
    super("dt");
  }

  static Dt opCall() {
    return new Dt();
  }

  static Dt opCall(string content) {
    auto dt = new Dt();
    dt.text(content);
    return dt;
  }
}
///
unittest {
  assert(Dt() == "<dt></dt>");
  assert(Dt("Term") == "<dt>Term</dt>");
}
