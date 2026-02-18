/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.month;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5MonthInput class represents an HTML <input> element with the type "month". It is used to create input fields that accept month and year values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "month" by default.
  * Example usage:
  * auto monthInput = H5MonthInput("month");
  * assert(monthInput == `<input type="month" name="month">`);
  * assert(monthInput.type() == "month");   
  * assert(monthInput.name() == "month");
  */
class H5MonthInput : H5Input {
  mixin H5InputThis!("month");

  mixin(H5Calls!("MonthInput"));
}
///
unittest {
  auto monthInput = H5MonthInput("month");
  assert(monthInput == `<input type="month" />`);
  assert(monthInput.type() == "month");
}