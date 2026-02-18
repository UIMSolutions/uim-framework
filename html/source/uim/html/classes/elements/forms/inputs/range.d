/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.range;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5RangeInput class represents an HTML <input> element with the type "range". It is used to create input fields that allow users to select a value from a specified range, and can include attributes such as min, max, step, and value to define the range and default value.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "range" by default.
  * Example usage:
  * auto rangeInput = H5RangeInput("volume");
  * assert(rangeInput == `<input type="range" name="volume">`);
  * assert(rangeInput.type() == "range");
  * assert(rangeInput.name() == "volume");
  */
class H5RangeInput : H5Input {
  mixin H5InputThis!("range");

  mixin(H5Calls!("RangeInput"));
}
///
unittest {
  auto rangeInput = H5RangeInput("volume");
  assert(rangeInput == `<input type="range" />`);
  assert(rangeInput.type() == "range");
}