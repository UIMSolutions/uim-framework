/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.bdo;

import uim.html;

mixin(ShowModule!());

@safe:

/** The <bdo> HTML element is used to override the current text direction. It can be used to display text in a different direction than the surrounding text, such as for displaying right-to-left text in a left-to-right context, or vice versa. The 'dir' attribute is used to specify the text direction, with possible values of 'ltr' (left-to-right) or 'rtl' (right-to-left).
*/
class H5Bdo : HtmlElement {
  mixin(H5This!("bdo", false));

mixin(AttributeMethods!H5Bdo);

  mixin(H5Calls!("Bdo"));
}
///
unittest {
  assert(H5Bdo() == "<bdo></bdo>");
  assert(H5Bdo("Hello") == "<bdo>Hello</bdo>");
}
