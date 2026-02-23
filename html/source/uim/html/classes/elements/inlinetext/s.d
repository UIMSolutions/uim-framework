/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.s;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <s> HTML element renders text with a strikethrough, indicating that the text is no longer accurate or relevant. 
  * It is often used to show deleted or outdated content, such as in a document revision history or to indicate a price reduction in an online store. 
  * The <s> element does not carry any semantic meaning and is purely presentational, so it should not be used to indicate that text is incorrect or should be ignored.
  *
  * Example usage:
  * <p>This is <s>old</s> text.</p>
  */
class H5S : HtmlElement {
  mixin(H5This!("s", false));

   mixin(AttributeMethods!H5S); 

  mixin(H5Calls!("s"));
}
///
unittest {
  assert(H5S() == "<s></s>");
  assert(H5S("Hello") == "<s>Hello</s>");
}
