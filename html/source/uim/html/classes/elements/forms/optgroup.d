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
@UDABoolAttribute("disabled")  // The 'disabled' attribute indicates that the optgroup is not available for interaction.  
class H5Optgroup : HtmlElement {
  mixin(HtmlTemplate!(H5Optgroup, "Optgroup", "optgroup", false));

  /// Sets the label attribute of the optgroup.
  H5Optgroup label(string val) {
    attribute("label", val);
    return this;
  }
}

unittest {
  assert(H5Optgroup() == `<optgroup></optgroup>`);
  assert(H5Optgroup(["testclass"]) == `<optgroup class="testclass"></optgroup>`);
  assert(H5Optgroup(["a":"b"]) == `<optgroup a="b"></optgroup>`);
  assert(H5Optgroup(["testclass"], ["a":"b"]) == `<optgroup class="testclass" a="b"></optgroup>`);

  assert(H5Optgroup("Hello") == `<optgroup>Hello</optgroup>`);
  assert(H5Optgroup(["testclass"], "Hello") == `<optgroup class="testclass">Hello</optgroup>`);
  assert(H5Optgroup(["a":"b"], "Hello") == `<optgroup a="b">Hello</optgroup>`);
  assert(H5Optgroup(["testclass"], ["a":"b"], "Hello") == `<optgroup class="testclass" a="b">Hello</optgroup>`);

  assert(H5Optgroup().label("Group 1") == `<optgroup label="Group 1"></optgroup>`);
  assert(H5Optgroup().disabled() == `<optgroup disabled></optgroup>`);
  assert(H5Optgroup().disabled(false) == `<optgroup></optgroup>`);
}
