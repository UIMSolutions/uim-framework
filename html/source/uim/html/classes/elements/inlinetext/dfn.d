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
@StringAttribute("title") // The 'title' attribute provides additional information about the term being defined.
class H5Dfn : HtmlElement {
  mixin(HtmlTemplate!(H5Dfn, "Dfn", "dfn", false));
}
///
unittest {
  assert(H5Dfn() == "<dfn></dfn>");
  assert(H5Dfn("Hello") == "<dfn>Hello</dfn>");
}
