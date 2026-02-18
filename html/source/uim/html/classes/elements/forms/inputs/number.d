/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.number;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The NumberInput class represents an HTML <input> element with the type "number". It is used to create a numeric input field that allows users to enter numbers, and can include attributes such as min, max, and step to control the range and increment of valid values.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "number" by default.
  * Example usage:
  * auto numberInput = H5NumberInput("age");
  * assert(numberInput == `<input type="number" name="age">`);
  * assert(numberInput.type() == "number");
  * assert(numberInput.name() == "age");
  */
class H5NumberInput : H5Input {
  mixin H5This!("input", false);

  override bool initialize(Json[string] initData = null) {
    super.initialize(initData);
    type("number");
    return true;
  }

  mixin(H5Calls!("NumberInput"));
}
///
unittest {
  auto numberInput = H5NumberInput("age");
  assert(numberInput == `<input type="number" name="age">`);
  assert(numberInput.type() == "number");
  assert(numberInput.name() == "age");  
}