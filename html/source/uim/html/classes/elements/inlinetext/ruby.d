/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.ruby;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <ruby> HTML element represents a ruby annotation, which is a small piece of text that is displayed above or below a base text to provide pronunciation or other information. 
  * It is commonly used in East Asian typography to indicate the pronunciation of Chinese characters (hanzi) or Japanese kanji. 
  * The <ruby> element typically contains one or more <rt> (ruby text) elements that specify the annotation text, and one or more <rp> (ruby parenthesis) elements that provide fallback content for browsers that do not support ruby annotations.
  *
  * Example usage:
  * <ruby>
  *   漢 <rp>(</rp><rt>kan</rt><rp>)</rp>
  *   字 <rp>(</rp><rt>ji</rt><rp>)</rp>
  * </ruby>
  */
class H5Ruby : HtmlElement {
  mixin(HtmlTemplate!(H5Ruby, "Ruby", "ruby", false));
}
///
unittest {
  assert(H5Ruby() == "<ruby></ruby>");
  assert(H5Ruby("Hello") == "<ruby>Hello</ruby>");
  assert(H5Ruby(["testclass"]) == `<ruby class="testclass"></ruby>`);
  assert(H5Ruby(["a": "b"]) == `<ruby a="b"></ruby>`);
}
