/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.fencedframe;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <fencedframe> HTML element is a non-standard element that is not part of the official HTML specification. 
 * It is used to create a fenced frame, which is a type of container that can be used to group and visually separate content on a web page. 
 * The <fencedframe> element typically has a border around it, and it can be styled using CSS to customize its appearance. 
 * However, since it is not a standard element, its behavior and support may vary across different web browsers, and it is generally recommended to use standard HTML elements for better compatibility and accessibility.
 *
 * Example usage:
 * ```html
 * <fencedframe>
 *   <p>This content is inside a fenced frame.</p>
 * </fencedframe>
 * ```
 * This would create a fenced frame containing a paragraph of text.
 */
class H5Fencedframe : HtmlElement {
  mixin(H5This!("fencedframe", false));

  mixin(H5Calls!("fencedframe"));
}
///
unittest {
  assert(H5Fencedframe() == "<fencedframe></fencedframe>");
  assert(H5Fencedframe("Hello") == "<fencedframe>Hello</fencedframe>");
}
