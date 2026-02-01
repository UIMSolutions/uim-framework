/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.checkbox;

import uim.html;

mixin(ShowModule!());

@safe:

class Checkbox : Input {
  this() {
    super("input");
    type("checkbox");
  }

  this(string tag) {
    super(tag);
    type("checkbox");
  }
}
