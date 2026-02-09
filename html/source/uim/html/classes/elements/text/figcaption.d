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
  * The <figcaption> HTML element represents a caption or legend for the content of its parent <figure> element. 
  * It is typically used to provide a description or explanation for an image, diagram, or other media content that is contained within the <figure> element. 
  * The <figcaption> element can contain any flow content, such as text, images, and other HTML elements, and it is usually displayed below the media content by default. 
  * When used in conjunction with the <figure> element, the <figcaption> element helps to provide context and meaning to the media content, making it more accessible and understandable to users.
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
