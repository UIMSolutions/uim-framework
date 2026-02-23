/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.rt;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <rt> HTML element specifies the ruby text component of a ruby annotation, which is used to provide pronunciation or other annotations for East Asian characters. 
  * The <rt> element is typically used in conjunction with the <ruby> and <rp> elements to create ruby annotations, which are commonly used in Japanese and Chinese writing systems. 
  * The <rt> element does not affect the meaning of the text it contains, but it indicates that the text should be displayed as a small annotation above or beside the base text.
  *
  * Example usage:
  * <ruby>漢 <rp>kan</rp><rt>かん</rt><rp>kan</rp> 字 <rp>ji</rp><rt>じ</rt><rp>ji</rp></ruby>
  */  
class H5Rt : HtmlElement {
  mixin(H5This!("rt", false));

  mixin(AttributeMethods!H5Rt);

  mixin(H5Calls!("Rt"));
}
///
unittest {
  assert(H5Rt() == "<rt></rt>");
  assert(H5Rt("Hello") == "<rt>Hello</rt>");
}
