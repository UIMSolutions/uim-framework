/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.scripting.noscript;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <noscript> element.
  * Provides methods to set the content of the noscript element.
  * Example usage:
  * auto noscript = Noscript("JavaScript is disabled in your browser.");
  */
class H5Noscript : HtmlElement {
  mixin(H5This!("noscript", false));
  mixin(AttributeMethods!H5Noscript);
  mixin(H5Calls!("noscript"));
}
///
unittest {
  assert(H5Noscript() == "<noscript></noscript>");
  assert(H5Noscript("Hello") == "<noscript>Hello</noscript>");
}
