/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.form;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * HTML form element
  * 
  * The <form> element represents a document section that contains interactive controls for submitting information to a web server. 
  * A form can contain various types of input elements, such as text fields, checkboxes, radio buttons, submit buttons, and more. 
  * The <form> element has attributes like action (the URL to which the form data will be sent) and method (the HTTP method to use when submitting the form). 
  * Forms are essential for collecting user input and facilitating interactions on websites.
  *
  * Example usage:
  *
  * <form action="/submit" method="POST">
  *   <label for="name">Name:</label>
  *   <input type="text" id="name" name="name"><br><br>
  *   <input type="submit" value="Submit">
  * </form>
 */
class H5Form : HtmlElement { // IHtmlForm {
  mixin H5This!("form", false);


  H5Form name() {
    attribute("name");
    return this;
  }

  H5Form name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }

  H5Form action(string url) {
    attribute("action", url);
    return this;
  }

  H5Form method(string methoUIMValue) {
    attribute("method", methoUIMValue);
    return this;
  }

  /// Sets the method attribute of the form to "POST".
  H5Form post() {
    method("POST");
    return this;
  }

  /// Sets the method attribute of the form to "GET".
    H5Form get() {
      method("GET");
      return this;  
  }

  /// Sets the enctype attribute of the form.
  H5Form enctype(string value) {
    attribute("enctype", value);
    return this;
  }

  mixin(H5Calls!("form"));
}
///
unittest {
  auto form = Form().action("/submit").post();
  assert(form.toString().indexOf("action=\"/submit\"") > 0);
}
