/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.form;

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
@StringAttribute("action")  // The action attribute specifies where to send the form data when the form is submitted.
@StringAttribute("method")  // The method attribute specifies the HTTP method to use when submitting the form (e.g., GET, POST).
@StringAttribute("name")  // The name attribute specifies the name of the form, which can be used to reference it in scripts or styles.
@StringAttribute("enctype")  // The enctype attribute specifies how the form data should be encoded when submitting it to the server.
class H5Form : HtmlElement { // IHtmlForm {
  mixin(H5This!("form", false));

  mixin(HtmlMethods!H5Form);

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

  mixin(H5Calls!("form"));
}
///
unittest {
  auto form = H5Form().action("/submit").post();
  assert(form.toString().indexOf("action=\"/submit\"") > 0);

  assert(H5Form() == "<form></form>");
  assert(H5Form("My Form") == "<form>My Form</form>");
  assert(H5Form(["testclass"]) == "<form class=\"testclass\"></form>");
  assert(H5Form(["a":"b"]) == "<form a=\"b\"></form>");

  assert(H5Form().action("/submit") == "<form action=\"/submit\"></form>");
  assert(H5Form().post() == "<form method=\"POST\"></form>");
  assert(H5Form().get() == "<form method=\"GET\"></form>");
  assert(H5Form().name("myForm") == "<form name=\"myForm\"></form>");
  assert(H5Form().enctype("multipart/form-data") == "<form enctype=\"multipart/form-data\"></form>");
  assert(H5Form().method("PUT") == "<form method=\"PUT\"></form>");
}
