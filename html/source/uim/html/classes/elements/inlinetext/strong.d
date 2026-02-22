/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.strong;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <strong> HTML element indicates that its contents have strong importance, seriousness, or urgency. 
 * Browsers typically render the contents in bold type.
 */
class H5Strong : HtmlElement {
  mixin H5This!("strong", false);

  mixin(AttributeMethods!H5Strong);

  mixin(H5Calls!("Strong"));
}
///
unittest {
  assert(H5Strong() == "<strong></strong>");
  assert(H5Strong("Hello") == "<strong>Hello</strong>");
}
