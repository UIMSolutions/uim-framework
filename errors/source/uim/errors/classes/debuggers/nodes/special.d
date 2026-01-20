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

  this(Json value) {
    _data = value;
  }

  protected Json _data;
  Json data() {
    return _data;
  }

  DSpecialErrorNode data(Json newData) {
    _data = newData;
    return this;
  }
}

/* unittest {
  // Test construction and data getter
  Json j = parseJsonString(`{"msg":"test error"}`);
  auto node = new DSpecialErrorNode(j);
  assert(node.data() == j, "Constructor or data() failed");

  // Test data setter (fluent interface)
  Json j2 = parseJsonString(`{"msg":"another error"}`);
  auto ret = node.data(j2);
  assert(ret is node, "data(Json) should return this");
  assert(node.data() == j2, "data(Json) did not set new value");

  // Test that protected _data is not accessible directly
  // static assert(!__traits(compiles, node._data), "_data should be protected");

  // Test with null Json
  Json jnull = Json(null);
  node.data(jnull);
  assert(node.data() == jnull, "data(Json) should accept null Json");
} */
