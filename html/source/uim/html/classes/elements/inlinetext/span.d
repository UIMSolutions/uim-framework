/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.span;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <span> HTML element is a generic inline container for phrasing content, which does not inherently represent anything. 
  * It can be used to group elements for styling purposes (using the class or id attributes), or because they share attribute values, such as lang. 
  * The <span> element itself does not provide any visual change by default, but it can be styled with CSS to create various effects.
  *
  * Example usage:
  * <p>This is a <span class="highlight">highlighted</span> word.</p>
  */
class H5Span : HtmlElement {
  mixin H5This!("span", false);

  mixin(H5Calls!("span"));
}
///
unittest {
  // TODO: // TODO: assert(H5Span() == "<span></span>");
  // TODO: writeln(H5Span("Text"));
  // TODO: assert(H5Span("Text") == "<span>Text</span>");
}
