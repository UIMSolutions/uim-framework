
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.br;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML line break element
class H5Br : HtmlElement {
  this() {
    super("br");
    this.selfClosing(true);
  }
   /// Creates a new <br> element.


  // Factory methods
  static H5Br opCall() {
    return new H5Br();
  }
}
///
unittest {
  assert(H5Br() == "<br />");
}
