/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.datetimelocal;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5DatetimelocalInput class represents an HTML <input> element with the type "datetimelocal". It is used to create input fields that accept datetimelocal values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "datetimelocal" by default.
  * Example usage:
  * auto datetimelocalInput = H5DatetimelocalInput("datetimelocal");
  * assert(datetimelocalInput == `<input type="datetimelocal" name="datetimelocal">`);
  * assert(datetimelocalInput.type() == "datetimelocal");
  * assert(datetimelocalInput.name() == "datetimelocal");
  */
class H5DatetimelocalInput : H5Input {
  mixin H5InputThis!("datetime-local");

  mixin(H5Calls!("DatetimelocalInput"));
}
///
unittest {
  auto datetimelocalInput = H5DatetimelocalInput("datetime-local");
  assert(datetimelocalInput == `<input type="datetime-local">`);
  assert(datetimelocalInput.type() == "datetime-local");
}