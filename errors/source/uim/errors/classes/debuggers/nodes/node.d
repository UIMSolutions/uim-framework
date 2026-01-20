/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.node;

import uim.errors;
mixin(ShowModule!());

@safe:

class UIMErrorNode : UIMObject, IErrorNode {
  mixin(ErrorNodeThis!());

  // #region value
  protected IErrorNode _value;
  IErrorNode value() {
    return _value;
  }

  IErrorNode value(IErrorNode newValue) {
    _value = newValue;
    return this;
  }
  // #endregion value

  // #region children
  // Get Item nodes
  protected IErrorNode[] _children;
  IErrorNode children(IErrorNode[] nodes) {
    _children = nodes;
    return this;
  }

  IErrorNode[] children() {
    if (_children.length == 0) {
      return [this.value];
    }
    return [this.value] ~ _children;
  }

  IErrorNode clearChildren() {
    _children = null;
    return this;
  }
  // #endregion children
}

unittest {
/*   Json json = Json.emptyObject;
  json["a"] = 1;

  auto node = new UIMErrorNode;
  node.value(json);
  assert(node.value["a"] == 1);
  assert(node.children.length == 0); */
}
