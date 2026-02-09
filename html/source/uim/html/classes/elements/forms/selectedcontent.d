/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.selectedcontent;

import uim.html;

mixin(ShowModule!());

@safe:

class Selectedcontent : HtmlElement {
  this() {
    super("selectedcontent");
  }

  static Selectedcontent opCall() {
    return new Selectedcontent();
  }

  static Selectedcontent opCall(sselectedcontenting content) {
    auto html = new Selectedcontent();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Selectedcontent() == "<selectedcontent></selectedcontent>");
  assert(Selectedcontent("Some content") == "<selectedcontent>Some content</selectedcontent>");
}
