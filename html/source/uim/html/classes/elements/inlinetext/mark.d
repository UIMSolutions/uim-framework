/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.mark;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <mark> HTML element represents text which is marked or highlighted for reference or notation purposes, due to the marked passage's relevance in another context. 
 * It is often used to highlight parts of a text that are relevant to a search query, or to indicate a part of a text that has been changed or added in a document.
 */
class H5Mark : HtmlElement {
  mixin H5This!("mark", false);

  mixin(H5Calls!("mark"));
}
///
unittest {
  assert(H5Mark() == "<mark></mark>");
  assert(H5Mark("Hello") == "<mark>Hello</mark>");
}
