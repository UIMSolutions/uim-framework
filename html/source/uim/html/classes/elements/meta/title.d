/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.title;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML title element
class Title : HtmlElement {
  this() {
    super("title");
    this.selfClosing(false);
  }

  static Title opCall() {
    return new Title();
  }

  static Title opCall(string content) {
    auto title = new Title();
    title.content(content);
    return title;
  }
}
/// 
