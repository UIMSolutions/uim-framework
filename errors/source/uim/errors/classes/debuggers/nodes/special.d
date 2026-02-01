/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.special;

import uim.errors;
mixin(ShowModule!());

@safe:

// Debug node for special messages like errors or recursion warnings.
class SpecialErrorNode : ErrorNode {
  mixin(ErrorNodeThis!("Special"));

  protected Json _data;
  Json data() {
    return _data;
  }

  SpecialErrorNode data(Json newData) {
    _data = newData;
    return this;
  }
}
