/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.array_;

import uim.errors;
mixin(ShowModule!());
@safe:


// Dump node for Array values.
class DArrayErrorNode : UIMErrorNode {
  mixin(ErrorNodeThis!("Array"));

  this(DArrayItemErrorNode[] nodes = null) {
    add(nodes);
  }

  void add(DArrayItemErrorNode[] nodes) {
    _children ~= nodes; 
  }
}
