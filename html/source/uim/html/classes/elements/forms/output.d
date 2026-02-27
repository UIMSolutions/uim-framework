/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.output;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <output> element.
  * The <output> element is used to represent the result of a calculation or user action.
  * It can be associated with form controls using the "for" attribute.
  * Example usage:
  * <output for="input1">Result will be displayed here</output>
  *
  * Note: The <output> element is typically used in conjunction with JavaScript to display dynamic results based on user input or interactions.
  *
  * The "for" attribute can reference one or more form control IDs, allowing the output to be associated with specific inputs.
  *
  * The content of the <output> element can be updated dynamically using JavaScript to reflect changes in the associated form controls.
  *
  * The <output> element can also be used to display the result of a calculation or user action without being associated with form controls.
  *
  * The <output> element is a block-level element and can contain text, inline elements, or other block-level elements.
  *
  * The <output> element is not submitted with the form data, but it can be used to display results or feedback to the user based on their interactions with the form.
  *
  * The <output> element can be styled using CSS to enhance its appearance and make it visually distinct from other elements on the page.
  *
  * Example usage:
  * <form oninput="result.value = parseInt(a.value) + parseInt(b.value)">
  *   <input type="number" id="a" name="a" value="0">
  *   <input type="number" id="b" name="b" value="0">
  *   <output name="result" for="a b">0</output>
  * </form>
  */
class H5Output : HtmlElement {
  mixin(H5This!("output", false));

  /// Associates the output element with other elements
  H5Output forElement(string elementId) {
    attribute("for", elementId);
    return this;
  }

  IHtmlAttribute forElement() {
    return attribute("for");
  }

  mixin(H5Calls!("Output"));
}
///
unittest {
  assert(H5Output() == `<output></output>`);
  assert(H5Output("Username:") == `<output>Username:</output>`);
  assert(H5Output().forElement("input1") == `<output for="input1"></output>`);
}
