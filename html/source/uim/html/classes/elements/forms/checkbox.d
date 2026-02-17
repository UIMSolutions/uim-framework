/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.checkbox;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Checkbox : H5Input {
  this() {
    super("input");
    type("checkbox");
  }

  this(string tag) {
    super(tag);
    type("checkbox");
  }

  static H5Checkbox opCall() {
    return new H5Checkbox();
  }
}
/// 
unittest {
  assert(H5Checkbox() == `<input type="checkbox" />`);
} 
