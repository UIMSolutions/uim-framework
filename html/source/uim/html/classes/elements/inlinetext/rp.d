/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.rp;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <rp> HTML element is used to provide fall-back parentheses for browsers that do not support display of ruby annotations using the <ruby> element. 
 * It is typically used in conjunction with the <rt> element, which specifies the ruby text (the annotation) that should be displayed above or below the base text (the content of the <ruby> element). 
 * The <rp> element allows authors to specify what should be displayed in place of the ruby text for browsers that do not support it, ensuring that the content remains readable and understandable even without ruby annotation support.
 */
class H5Rp : HtmlElement {
  mixin H5This!("rp", false);

  mixin(H5Calls!("rp"));
}
///
unittest {
  assert(H5Rp() == "<rp></rp>");
  assert(H5Rp("Hello") == "<rp>Hello</rp>");
}
