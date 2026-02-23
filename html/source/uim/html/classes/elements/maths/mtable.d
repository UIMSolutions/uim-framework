/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mtable;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mtable> HTML element represents a mathematical table. 
  * It is used within the <math> element to create a table layout for mathematical expressions, such as matrices or arrays.
  */
class H5Mtable : HtmlElement {
  mixin(H5This!("mtable", false));

  mixin(AttributeMethods!H5Mtable);
  
  mixin(H5Calls!("Mtable"));
}
///
unittest {
  assert(H5Mtable() == "<mtable></mtable>");
  assert(H5Mtable("Hello") == "<mtable>Hello</mtable>");
}
