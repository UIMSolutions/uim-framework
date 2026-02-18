/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.hidden;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The HiddenInput class represents an HTML <input> element with the type "hidden". It is used to store data that should be sent to the server when a form is submitted, but is not visible to the user.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "hidden" by default.
  * Example usage:
  * auto hiddenInput = H5HiddenInput("token");
  * assert(hiddenInput == `<input type="hidden" name="token">`);
  * assert(hiddenInput.type() == "hidden");
  * assert(hiddenInput.name() == "token");
  */
class H5HiddenInput : H5Input {
  mixin H5This!("input", false);

  override bool initialize(Json[string] initData = null) {
    super.initialize(initData);
    type("hidden");
    return true;
  }

  mixin(H5Calls!("HiddenInput"));
}
///
unittest {
  auto hiddenInput = H5HiddenInput("token");
  assert(hiddenInput == `<input type="hidden" name="token">`);
  assert(hiddenInput.type() == "hidden");
  assert(hiddenInput.name() == "token");  
}