/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.textarea;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * HTML textarea element
  * 
  * The <textarea> element represents a multi-line plain-text editing control. It is commonly used in forms to allow users to input longer text, such as comments, messages, or descriptions.
  * 
  * Example usage:
  * 
  * <textarea name="message" rows="4" cols="50" placeholder="Enter your message here..."></textarea>
  *
  * The <textarea> element can be configured with attributes like name, rows, cols, placeholder, required, disabled, and readonly to control its behavior and appearance.
  */
  @StringAttribute("name") // The 'name' attribute specifies the name of the textarea, which is used when submitting form data.
  @StringAttribute("rows") // The 'rows' attribute specifies the visible number of lines in the textarea.
  @StringAttribute("cols") // The 'cols' attribute specifies the visible width of the textarea in characters.
  @StringAttribute("placeholder") // The 'placeholder' attribute provides a hint to the user of what can be entered in the textarea.
  @BoolAttribute("required") // The 'required' attribute indicates that the textarea must be filled out before submitting the form.
  @BoolAttribute("disabled") // The 'disabled' attribute indicates that the textarea is not available for interaction.
  @BoolAttribute("readonly") // The 'readonly' attribute indicates that the textarea is read-only and cannot be modified by the user.
class H5Textarea : HtmlElement {
  mixin(H5This!("textarea", false));

  mixin(AttributeMethods!H5Textarea);

  H5Textarea rows(size_t rowCount) {
    attribute("rows", rowCount.to!string);
    return this;
  }

  H5Textarea cols(size_t colCount) {
    attribute("cols", colCount.to!string);
    return this;
  }

  mixin(H5Calls!("textarea"));
}
///
unittest {
  assert(H5Textarea() == "<textarea></textarea>");
  assert(H5Textarea("Hello") == "<textarea>Hello</textarea>");
  assert(H5Textarea(["test"], "Hello") == `<textarea class="test">Hello</textarea>`);
  assert(H5Textarea(["a": "b"], "Hello") == `<textarea a="b">Hello</textarea>`);
  assert(H5Textarea(["test"], ["a": "b"], "Hello") == `<textarea class="test" a="b">Hello</textarea>`);

  assert(H5Textarea().name("message") == `<textarea name="message"></textarea>`);
  assert(H5Textarea().name("message").name() == "message");
  
  assert(H5Textarea().rows(4) == `<textarea rows="4"></textarea>`);
  assert(H5Textarea().rows("4") == `<textarea rows="4"></textarea>`);
  assert(H5Textarea().rows("4").rows() == "4");
  
  assert(H5Textarea().cols(50) == `<textarea cols="50"></textarea>`);
  assert(H5Textarea().cols("50") == `<textarea cols="50"></textarea>`);
  assert(H5Textarea().cols("50").cols() == "50");

  assert(H5Textarea().placeholder("Enter your message here...") == `<textarea placeholder="Enter your message here..."></textarea>`);
  assert(H5Textarea().placeholder("Enter your message here...").placeholder() == "Enter your message here...");
  
  assert(H5Textarea().required() == `<textarea required></textarea>`);
  assert(H5Textarea().required().isRequired() == true);

  assert(H5Textarea().disabled() == `<textarea disabled></textarea>`);
  assert(H5Textarea().disabled().isDisabled() == true);

  assert(H5Textarea().readonly() == `<textarea readonly></textarea>`);
  assert(H5Textarea().readonly().isReadonly() == true);
}
