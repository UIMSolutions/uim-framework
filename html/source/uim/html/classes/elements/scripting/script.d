/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.scripting.script;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <script> element.
  * Provides methods to set the content of the script element.
  * Example usage:
  * auto script = Script("console.log('Hello, World!');");
  *
  * The <script> element is used to embed or reference executable code within an HTML document.
  * It is commonly used to include JavaScript code that can manipulate the content and behavior of the web page. The content of the <script> element can be either inline code or a reference
  * to an external script file using the "src" attribute. When the browser encounters a <script> element, it executes the code contained within it or fetches and executes the external script.
  *
  */
class H5Script : HtmlElement {
  mixin(H5This!("script", false));

  mixin(HtmlMethods!H5Script);

  mixin(H5Calls!("script"));
}
///
unittest {
  assert(H5Script() == "<script></script>");
  assert(H5Script("Hello") == "<script>Hello</script>");
}
