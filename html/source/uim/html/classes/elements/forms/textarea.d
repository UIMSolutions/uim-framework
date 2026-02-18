/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.textarea;

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
class H5Textarea : HtmlElement {
  mixin H5This!("textarea", false);

  IHtmlAttribute name() {
    return attribute("name");
  }

  H5Textarea name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }

  H5Textarea rows(string rowCount) {
    attribute("rows", rowCount);
    return this;
  }

  IHtmlAttribute rows() {
    return attribute("rows");
  }

  H5Textarea cols(string colCount) {
    attribute("cols", colCount);
    return this;
  }

  IHtmlAttribute cols() {
    return attribute("cols");
  }

  H5Textarea placeholder(string text) {
    attribute("placeholder", text);
    return this;
  }

  IHtmlAttribute placeholder() {
    return attribute("placeholder");
  }

  H5Textarea required() {
    attribute("required", "");
    return this;
  }

  H5Textarea disabled() {
    attribute("disabled", "");
    return this;
  }

  H5Textarea readonly() {
    attribute("readonly", "");
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
}
