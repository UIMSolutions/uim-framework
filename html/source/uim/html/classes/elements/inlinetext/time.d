/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.time;

import uim.html;

mixin(ShowModule!());

@safe:

// The <time> HTML element represents a specific period in time. It may include the datetime attribute to translate dates into machine-readable format, which can be used by user agents for various purposes, such as sorting events in a calendar, or providing a more accurate date for a search engine result.
class Time : HtmlElement {
  this() {
    super("time");
    this.selfClosing(false);
  }

  static Time opCall() {
    return new Time();
  }

  static Time opCall(string content) {
    auto element = new Time();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Time() == "<time></time>");
  assert(Time("Hello") == "<time>Hello</time>");
}
