/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.property;

import uim.errors;
mixin(ShowModule!());

@safe:

// Dump node for object properties.
class DPropertyErrorNode : UIMErrorNode {
  mixin(ErrorNodeThis!("Property"));

  private IErrorNode _propertyValue;

  this(string name, string visibility, IErrorNode node) {
    super();

    this.objName(name);
    this.visibility(visibility);
    this.value(node);
  }

  // #region visibility
  // Get the property visibility
  private string _visibility;
  IErrorNode visibility(string newVisibility) {
    _visibility = newVisibility;
    return this;
  }

  string visibility() {
    return _visibility;
  }
  // #endregion visibility

  override IErrorNode[] children() {
    return [this.value];
  }
}

/* 
unittest {
  auto dummy = new UIMErrorNode("dummyValue");
  auto node = new DPropertyErrorNode("propName", "public", dummy);

  // Act & Assert
  assert(node.name == "propName");
  assert(node.visibility() == "public");
  assert(node.value() is dummy);
  assert(node.children().length == 1);
  assert(node.children()[0] is dummy);

  // Test visibility setter
  node.visibility("private");
  assert(node.visibility == "private");
  assert(node.visibility != "public");
}
*/