/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.elements.element;

import uim.entities;

mixin(ShowModule!());

@safe:
class ElementValue : UIMValue {
  this() {
    super;
  }

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .isNull(false);
  }

  protected UIMElement _value;
  alias value = UIMValue.value;
  O value(this O)(UIMElement newValue) {
    _value = newValue;
    return cast(O)this;
  }

  UIMElement value() {
    return _value;
  }

  version (test_uim_models) {
    unittest {
      auto Element = SystemUser; // some kind of Element
      assert(ElementValue.value(Element).value.id == Element.id);
    }
  }

  override void set(string newValue) {
    /// TODO
  }

  override void set(Json newValue) {
    /// TODO
  }

  void set(UIMElement newValue) {
    if (newValue) {
      this.isNull(false);
      _value = newValue;
      return;
    }

    if (isNullable) {
      this.isNull(true);
      _value = null;
    }
  }

  alias opEquals = UIMValue.opEquals;
  bool opEquals(ElementValue otherValue) {
    string left = value.toString;
    string right = otherValue.value.toString;
    return (left == right);
  }

  bool opEquals(UIMElement otherValue) {
    return (value.toString == otherValue.toString);
  }

  override bool opEquals(string otherValue) {
    return (value.toString == otherValue);
  }

  /*   int opCmp(UIMElement otherValue) {
    /// TODO
    return 1;
  }  */

  override UIMValue copy() {
    return new ElementValue(attribute, toJson);
  }

  override Json toJson() {
    if (isNull)
      return Json(null);
    return this.value.toJson;
  }

  // ElementValue converts to a JsonSTtring
  override string toString() {
    if (isNull)
      return null;
    return this.value.toString;
  }

  override void fromString(string newValue) {
    /// TODO this.value(newValue);
  }
}
