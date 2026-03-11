/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.mmultiscripts;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <mmultiscripts> HTML element represents a mathematical expression with multiple scripts, such as subscripts and superscripts. 
  * It is used within the <math> element to define complex mathematical notations that involve multiple levels of scripts.
  */
class H5Mmultiscripts : HtmlElement {
  mixin(HtmlTemplate!(H5Mmultiscripts, "Mmultiscripts", "mmultiscripts", false));
}
///
unittest {
  assert(H5Mmultiscripts() == "<mmultiscripts></mmultiscripts>");
  assert(H5Mmultiscripts("Hello") == "<mmultiscripts>Hello</mmultiscripts>");
}
