/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.geolocation;

import uim.html;

mixin(ShowModule!());

@safe:

class Geolocation : HtmlElement {
  this() {
    super("geolocation");
    this.selfClosing(false);
  }

  // Factory methods
  static Geolocation opCall() {
    return new Geolocation();
  }

  // Factory methods
  static Geolocation opCall(string content) {
    auto html = new Geolocation();
    html.content(content);
    return html;
  }

}
///
unittest {
  assert(Geolocation() == "<geolocation></geolocation>");
  assert(Geolocation("Some content") == "<geolocation>Some content</geolocation>");
}
