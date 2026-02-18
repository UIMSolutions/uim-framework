/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.time;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5TimeInput class represents an HTML <input> element with the type "time". It is used to create input fields that accept time values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "time" by default.
  * Example usage:
  * auto timeInput = H5TimeInput("time");
  * assert(timeInput == `<input type="time" name="time">`);
  * assert(timeInput.type() == "time");
  * assert(timeInput.name() == "time");
  */
class H5TimeInput : H5Input {
  mixin H5InputThis!("time");

  mixin(H5Calls!("TimeInput"));
}
///
unittest {
  auto timeInput = H5TimeInput("time");
  assert(timeInput == `<input type="time" name="time">`);
  assert(timeInput.type() == "time");
  assert(timeInput.name() == "time");  
}