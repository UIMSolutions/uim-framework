/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.date;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5DateInput class represents an HTML <input> element with the type "date". It is used to create input fields that allow users to select a date, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "date" by default.
  * Example usage:
  * auto dateInput = H5DateInput("date");
  * assert(dateInput == `<input type="date" name="date">`);
  * assert(dateInput.type() == "date");
  * assert(dateInput.name() == "date");
  */
class H5DateInput : H5Input {
  mixin H5InputThis!("date");

  mixin(H5Calls!("DateInput"));
}
///
unittest {
  auto dateInput = H5DateInput("date");
  assert(dateInput == `<input type="date" />`);
  assert(dateInput.type() == "date");
}