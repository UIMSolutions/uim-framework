/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.datalist;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * HTML datalist element
  * The <datalist> element contains a set of <option> elements that represent the permissible or recommended options available to users in other controls.
  * The <datalist> element is used to provide an "autocomplete" feature for <input> elements. It contains a set of <option> elements that represent the permissible or recommended options available to users in other controls.
  * The <datalist> element is not displayed on its own. It must be referenced by a form control, such as an <input> element, using the list attribute.
  * 
  * Example usage:
  * 
  * <input list="browsers" name="browser">
  * <datalist id="browsers">
  *   <option value="Internet Explorer">
  *   <option value="Firefox">
  *   <option value="Chrome">
  *   <option value="Opera">
  *   <option value="Safari">
  * </datalist>
  */
class H5Datalist : FormElement {
  this() {
    super("datalist");
  }

  static H5Datalist opCall() {
    return new H5Datalist();
  }

  static H5Datalist opCall(string text) {
    auto html = new H5Datalist();
    html.text(text);
    return html;
  }
}
/// 
unittest {
  assert(H5Datalist() == "<datalist></datalist>");
  assert(H5Datalist("Some content") == "<datalist>Some content</datalist>");
}
