/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mphantom;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mphantom> HTML element represents an invisible element in a mathematical expression. 
  * It is used within the <math> element to create space without displaying any content.
  */
class H5Mphantom : HtmlElement {
  mixin(HtmlTemplate!(H5Mphantom, "Mphantom", "mphantom", false));
}
///
unittest {
  assert(H5Mphantom() == "<mphantom></mphantom>");
  assert(H5Mphantom("Hello") == "<mphantom>Hello</mphantom>");
}
