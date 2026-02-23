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
class H5Title : HtmlElement {
  mixin(H5This!("title", false));

  mixin(AttributeMethods!H5Title);

  mixin(H5Calls!("Title"));
}
/// 
unittest {
  assert(H5Title() == `<title></title>`);
  assert(H5Title("My Page Title") == `<title>My Page Title</title>`);
}
