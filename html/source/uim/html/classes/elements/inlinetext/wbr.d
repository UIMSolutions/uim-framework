/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.wbr;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <wbr> (Word Break Opportunity) element represents a position within text where the browser may optionally break a line.
  * It is an empty element, meaning it has no content and does not require a closing tag.
  * The <wbr> element is used to indicate potential line break points in long words or URLs, allowing for better text wrapping and readability.
  * When the browser encounters a <wbr> element, it can choose to break the line at that point if necessary, but it will not force a break if it is not needed.
  * This can be particularly useful for improving the display of long strings of text, such as URLs or long words, without affecting the overall layout of the page.
  *
  * Example usage:
  * <p>This is a long word: supercalifragilisticexpialidocious<wbr> which may break at the wbr point.</p>
  */
class H5Wbr : HtmlElement {
  mixin H5This!("wbr", true);

  mixin(H5Calls!("wbr"));
}
///
unittest {
  writeln(H5Wbr());
  assert(H5Wbr() == "<wbr></wbr>");
  assert(H5Wbr("Hello") == "<wbr>Hello</wbr>");
  assert(H5Wbr(["test"], "Hello") == `<wbr class="test">Hello</wbr>`);
  assert(H5Wbr(["a": "b"], "Hello") == `<wbr a="b">Hello</wbr>`);
  assert(H5Wbr(["test"], ["a": "b"], "Hello") == `<wbr class="test" a="b">Hello</wbr>`);
}
