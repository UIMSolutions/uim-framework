/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.week;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5WeekInput class represents an HTML <input> element with the type "week". It is used to create input fields that accept week values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "week" by default.
  * Example usage:
  * auto weekInput = H5WeekInput("week");
  * assert(weekInput == `<input type="week" name="week">`);
  * assert(weekInput.type() == "week");
  * assert(weekInput.name() == "week");
  */
class H5WeekInput : H5Input {
  mixin H5InputThis!("week");

  mixin(H5Calls!("WeekInput"));
}
///
unittest {
  auto weekInput = H5WeekInput("week");
  assert(weekInput == `<input type="week" />`);
  assert(weekInput.type() == "week");
}