/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.math;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<math>` element, which is used to include mathematical expressions in a web page. The `<math>` element is part of the MathML (Mathematical Markup Language) specification, which provides a way to represent mathematical notation and structure in a machine-readable format.
  * 
  * The `<math>` element can contain various MathML elements to represent different types of mathematical expressions, such as fractions, square roots, integrals, and more. It allows for the display of complex mathematical formulas and equations on web pages.
  * 
  * Browser support: All major browsers support the `<math>` element and MathML.
  *
  * Examples:
  * ```html
  * <math>
  *   <mfrac>
  *     <mi>a</mi>
  *     <mi>b</mi>
  *   </mfrac>
  * </math>
  * ```
  */
class H5Math : HtmlElement {
  this() {
    super("math");
    this.selfClosing(false);
  }

  // Factory methods
  static H5Math opCall() {
    return new H5Math();
  }

  // Factory methods
  static H5Math opCall(string content) {
    auto element = new H5Math();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(H5Math() == "<math></math>");
  assert(H5Math("Hello") == "<math>Hello</math>");
}
