/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.caption;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <caption> HTML element specifies the caption (or title) of a table. It must be inserted immediately after the <table> tag.
  * The <caption> element is used to describe the contents of the table, and it is typically displayed above the table by default.
  * However, you can use CSS to change its position and style as needed.
  */
class Caption : HtmlElement {
  this() {
    super("caption");
  }

  static Caption opCall() {
    return new Caption();
  }

  static Caption opCall(string content) {
    auto html = new Caption();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Caption() == "<caption></caption>");
  assert(Caption("Row content") == "<caption>Row content</caption>");
}
