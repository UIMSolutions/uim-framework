/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.figcaption;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <figcaption> HTML element represents a caption or legend for a <figure> element. 
 * It is used to provide a description or explanation for the content of the <figure>, such as an image, diagram, or code snippet. 
 * The <figcaption> element is typically placed as the first or last child of the <figure> element, and it can contain text, images, or other HTML elements to provide context and information about the content of the figure. 
 * It is an optional element, but it can enhance the accessibility and usability of the content by providing additional information to users.
 *
 * Examples:
 * ```html
 * <figure>  
 *   <img src="image.jpg" alt="A description of the image">
 *   <figcaption>This is a caption for the image.</figcaption>
 * </figure>
 * ```
 */
class Figcaption : HtmlElement {
  this() {
    super("figcaption");
  }

  static Figcaption opCall() {
    return new Figcaption();
  }

  static Figcaption opCall(string content) {
    auto figcaption = new Figcaption();
    figcaption.text(content);
    return figcaption;
  }
}
///
unittest {
  assert(Figcaption() == "<figcaption></figcaption>");
  assert(Figcaption("Description") == "<figcaption>Description</figcaption>");
}
