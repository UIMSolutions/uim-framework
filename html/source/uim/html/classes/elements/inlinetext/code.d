/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.code;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * The <code> element represents a fragment of computer code. 
  * By default, it is displayed in the browser's default monospace font. 
  * It is used to denote a fragment of code, such as a variable name, a function name, or a piece of code in a programming language.
  *
  * The <code> element is typically used in conjunction with the <pre> element, which represents preformatted text. 
  * When used together, the <pre> element preserves whitespace and line breaks, while the <code> element indicates that the content is code.
  * Example usage:
  * <pre><code>int main() {
  *   return 0;
  * }</code></pre>
  */
class H5Code : HtmlElement {
  mixin(HtmlTemplate!(H5Code, "Code", "code", false));
}
///
unittest {
  assert(H5Code() == "<code></code>");
  assert(H5Code(["testclass"]) == "<code class=\"testclass\"></code>");
  assert(H5Code(["a":"b"]) == "<code a=\"b\"></code>");
  assert(H5Code(["testclass"], ["a":"b"]) == "<code class=\"testclass\" a=\"b\"></code>");

  assert(H5Code("Hello") == "<code>Hello</code>");
  assert(H5Code(["testclass"], "Hello") == "<code class=\"testclass\">Hello</code>");
  assert(H5Code(["a":"b"], "Hello") == "<code a=\"b\">Hello</code>");
  assert(H5Code(["testclass"], ["a":"b"], "Hello") == "<code class=\"testclass\" a=\"b\">Hello</code>");
}
