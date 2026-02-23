/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.caption;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents an HTML <caption> element.
  * Provides methods to set the content of the caption element.
  * Example usage:
  * auto caption = Caption("Table Caption");
  */
class H5Caption : HtmlElement {
  mixin(H5This!("caption", false));

  mixin(AttributeMethods!H5Caption);

  mixin(H5Calls!("caption"));
}
///
unittest {
  assert(H5Caption() == "<caption></caption>");
  assert(H5Caption("Hello") == "<caption>Hello</caption>");
}
