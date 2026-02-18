/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mtd;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Mtd : HtmlElement {
  mixin H5This!("mtd", false);

  mixin(H5Calls!("mtd"));
}
///
unittest {
  assert(H5Mtd() == "<mtd></mtd>");
  assert(H5Mtd("Hello") == "<mtd>Hello</mtd>");
}
