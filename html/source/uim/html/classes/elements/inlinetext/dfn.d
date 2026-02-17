/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.dfn;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * The <dfn> element represents the defining instance of a term. 
  * It is used to indicate that the content is a definition of a term, and it can be used in conjunction with the <abbr> element to provide an abbreviation for the term.
  * Example usage:
  * auto dfn = Dfn("HTML").title("HyperText Markup Language");
  * Note: The <dfn> element is typically used in conjunction with JavaScript to provide additional functionality, such as displaying a tooltip with the definition when the user hovers over the term.
  */
class H5Dfn : HtmlElement {
  mixin H5This!("dfn", false);

   /// Sets the title attribute of the definition.
  H5Dfn title(string val) {
    attribute("title", val);
    return this;
  }

  mixin(H5Calls!("Dfn"));
}
///
unittest {
  assert(H5Dfn() == "<dfn></dfn>");
  assert(H5Dfn("Hello") == "<dfn>Hello</dfn>");
}
