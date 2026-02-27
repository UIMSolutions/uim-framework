/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.math;

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
  @StringAttribute("display") // The display attribute specifies the display style of the mathematical expression, such as "inline" or "block".
class H5Math : HtmlElement {
  mixin(H5This!("math", false));

  mixin(AttributeMethods!H5Math);

  mixin(H5Calls!("Math"));
}
///
unittest {
  assert(H5Math() == "<math></math>");

  assert(H5Math("Some content") == "<math>Some content</math>");
  assert(H5Math(["testClass"]) == `<math class="testClass"></math>`);
  assert(H5Math(["a": "b"]) == `<math a="b"></math>`);

  assert(H5Math(["testClass"], "Some content") == `<math class="testClass">Some content</math>`);
  assert(H5Math(["a": "b"], "Some content") == `<math a="b">Some content</math>`);

  assert(H5Math(["testClass"], ["a": "b"], "Some content") == `<math class="testClass" a="b">Some content</math>`);
}
