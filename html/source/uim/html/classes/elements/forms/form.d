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
  * Represents an HTML <form> element.
  * Provides methods to set form attributes like action, method, and enctype.
  */
class H5Form : HtmlElement, IHtmlForm {
  mixin H5This!("form", false);



  H5Form name() {
    attribute("name");
    return this;
  }

  override H5Form name(string nameValue) {
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
