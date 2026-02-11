/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.class_;

import uim.errors;
mixin(ShowModule!());

@safe:

// Dump node for objects/class instances.
class ClassErrorNode : ErrorNode {
  mixin(ErrorNodeThis!("Class"));

  this(string classname, int anId) {
    super();
    this.classname(classname);
    this.id(anId);
  }

  // Add a property
  void addProperty(PropertyErrorNode node) {
    _children ~= node;
  }

  private string _classname;
  // Get the class name
  string classname() {
    return _classname;
  }

  ClassErrorNode classname(string name) {
    _classname = name;
    return this;
  }

  private int _id;
  // Get the reference id
  int id() {
    return _id;
  }

  ClassErrorNode id(int newId) {
    _id = newId;
    return this;
  }
}

/* unittest {
  // Test addProperty actually adds to _children
  auto node = new ClassErrorNode("TestClass", 1);

  auto dummy1 = new ScalarErrorNode("string", Json("dummyValue1"));  
  auto property1 = new PropertyErrorNode("propName1", "public", dummy1);

  auto dummy2 = new ScalarErrorNode("string", Json("dummyValue2"));  
  auto property2 = new PropertyErrorNode("propName2", "private", dummy2);

  node.addProperty(property1);
  node.addProperty(property2);

  auto node2 = new ClassErrorNode("TestClass2", 2);

  node2.addProperty(property1);
  node2.addProperty(property2);

  auto property3 = new PropertyErrorNode("class1", "protected", node2);
  node.addProperty(property3);

  // Downcast to access _children for testing
  /* auto children = node.children;
  assert(children.length == 2, "addProperty did not add nodes correctly");
  assert(children[0] is prop1, "First property not added correctly");
  assert(children[1] is prop2, "Second property not added correctly"); * /

  writeln(TextErrorFormatter.dump(node));
} */
