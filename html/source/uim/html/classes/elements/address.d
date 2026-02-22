/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.address;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <address> element.
  * Provides methods to set the content of the address element.
  * Example usage:
  * auto address = Address("123 Main St, Anytown, USA");
  */
class H5Address : HtmlElement {
  mixin H5This!("address", false);

  mixin(StringAttributeMethods!H5Address);

  mixin(H5Calls!("address"));
}
///
unittest {
  assert(H5Address() == "<address></address>");
  assert(H5Address("Hello") == "<address>Hello</address>");
}
