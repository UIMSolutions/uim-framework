/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.special;

import uim.errors;
mixin(ShowModule!());

@safe:

// Debug node for special messages like errors or recursion warnings.
class DSpecialErrorNode : UIMErrorNode {
  mixin(ErrorNodeThis!("Special"));

  protected Json _data;
  Json data() {
    return _data;
  }

  DSpecialErrorNode data(Json newData) {
    _data = newData;
    return this;
  }
}
