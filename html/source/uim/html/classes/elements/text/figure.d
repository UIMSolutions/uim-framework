/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.figure;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <figure> HTML element represents self-contained content, frequently with a caption (figcaption), and is typically referenced as a single unit. 
 * It is used to group media content, such as images, diagrams, photos, code snippets, or other illustrations, along with their associated caption or description. 
 * The <figure> element can be used to provide context and meaning to the media content, making it more accessible and understandable to users. 
 * When used in conjunction with the <figcaption> element, the <figure> element helps to create a clear association between the media content and its caption or description.
 */
class Figure : HtmlElement {
  this() {
    super("figure");
  }

  static Figure opCall() {
    return new Figure();
  }

  static Figure opCall(string content) {
    auto figure = new Figure();
    figure.text(content);
    return figure;
  }
}
///
unittest {
  assert(Figure() == "<figure></figure>");
  assert(Figure("Description") == "<figure>Description</figure>");
}
