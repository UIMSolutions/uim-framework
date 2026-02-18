/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.checkbox;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <input type="checkbox"> HTML element represents a checkbox, which is a form control that allows users to select one or more options from a set. 
  * A checkbox is typically displayed as a small square box that can be checked (selected) or unchecked (deselected) by the user. 
  * The <input type="checkbox"> element can be used in forms to gather user input, and it can be styled using CSS to customize its appearance. 
  * When a checkbox is checked, its value is submitted with the form data, allowing the server to process the user's selection.
  *
  * Example usage:
  * <form>
  *   <label><input type="checkbox" name="option1" value="Option 1"> Option 1</label><br>
  *   <label><input type="checkbox" name="option2" value="Option 2"> Option 2</label><br>
  *   <label><input type="checkbox" name="option3" value="Option 3"> Option 3</label><br>
  *   <input type="submit" value="Submit">
  * </form>
 */
class H5Checkbox : H5Input {
  mixin H5InputThis!("checkbox");

  mixin(H5Calls!("Checkbox"));
}
/// 
unittest {
  assert(H5Checkbox() == `<input type="checkbox" />`);
} 
