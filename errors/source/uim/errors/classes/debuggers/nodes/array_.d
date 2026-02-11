/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.array_;

import uim.errors;
mixin(ShowModule!());
@safe:


// Dump node for Array values.
class ArrayErrorNode : ErrorNode {
  mixin(ErrorNodeThis!("Array"));

  this(ArrayItemErrorNode[] nodes = null) {
    add(nodes);
  }

  void add(ArrayItemErrorNode[] nodes) {
    _children ~= nodes; 
  }
}
