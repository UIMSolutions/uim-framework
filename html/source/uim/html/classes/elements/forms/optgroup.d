/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.optgroup;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <optgroup> element.
  * Provides methods to set optgroup attributes and content.
  * Example usage:
  * auto group = Optgroup("Group 1");
  *
  * Note: The <optgroup> element is used to group related options in a dropdown list.
  */
class H5Optgroup : HtmlElement {
  mixin H5This!("optgroup", false);

  /// Sets the label attribute of the optgroup.
  H5Optgroup label(string val) {
    attribute("label", val);
    return this;
  }

  /// Sets the disabled attribute of the optgroup.
  H5Optgroup disabled(bool val = true) {
    if (val) {
      attribute("disabled", "disabled");
    } else {
      removeAttribute("disabled");
    } 
    return this;
  }

  mixin(H5Calls!("Optgroup"));
}

unittest {
  assert(H5Optgroup() == "<optgroup></optgroup>");
  assert(H5Optgroup("Hello") == "<optgroup>Hello</optgroup>");
  assert(H5Optgroup().label("Group 1") == "<optgroup label=\"Group 1\"></optgroup>");
  assert(H5Optgroup().disabled() == "<optgroup disabled=\"disabled\"></optgroup>");
  assert(H5Optgroup().disabled(false) == "<optgroup></optgroup>");

}
