/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.composites;

import uim.oop;
import std.stdio;

@safe:

// Test leaf component
unittest {
  auto leaf = new Leaf("MyLeaf", "LeafValue");
  
  assert(leaf.name() == "MyLeaf", "Leaf name should match");
  assert(leaf.value() == "LeafValue", "Leaf value should match");
  assert(leaf.execute() == "LeafValue", "Execute should return value");
  assert(!leaf.isComposite(), "Leaf should not be composite");
}

// Test composite component
unittest {
  auto composite = new Composite("Parent");
  
  assert(composite.isComposite(), "Composite should be composite");
  assert(composite.childCount() == 0, "Should start with no children");
  
  composite.add(new Leaf("Child1", "A"));
  assert(composite.childCount() == 1, "Should have 1 child");
  
  composite.add(new Leaf("Child2", "B"));
  assert(composite.childCount() == 2, "Should have 2 children");
  
  auto result = composite.execute();
  assert(result == "A, B", "Should execute all children");
}

// Test nested composites
unittest {
  auto root = new Composite("Root");
  auto branch1 = new Composite("Branch1");
  auto branch2 = new Composite("Branch2");
  
  branch1.add(new Leaf("Leaf1", "A"));
  branch1.add(new Leaf("Leaf2", "B"));
  
  branch2.add(new Leaf("Leaf3", "C"));
  branch2.add(new Leaf("Leaf4", "D"));
  
  root.add(branch1);
  root.add(branch2);
  
  assert(root.childCount() == 2, "Root should have 2 branches");
  assert(branch1.childCount() == 2, "Branch1 should have 2 leaves");
  assert(branch2.childCount() == 2, "Branch2 should have 2 leaves");
  
  auto result = root.execute();
  assert(result == "A, B, C, D", "Should execute entire tree");
}

// Test add and remove
unittest {
  auto composite = new Composite("Parent");
  auto child1 = new Leaf("Child1", "A");
  auto child2 = new Leaf("Child2", "B");
  auto child3 = new Leaf("Child3", "C");
  
  composite.add(child1);
  composite.add(child2);
  composite.add(child3);
  assert(composite.childCount() == 3, "Should have 3 children");
  
  composite.remove(child2);
  assert(composite.childCount() == 2, "Should have 2 children after remove");
  
  auto result = composite.execute();
  assert(result == "A, C", "Should execute remaining children");
}

// Test get child
unittest {
  auto composite = new Composite("Parent");
  auto child1 = new Leaf("Child1", "First");
  auto child2 = new Leaf("Child2", "Second");
  
  composite.add(child1);
  composite.add(child2);
  
  auto retrieved = composite.getChild(0);
  assert(retrieved !is null, "Should get child");
  assert(retrieved.name() == "Child1", "Should get correct child");
  
  retrieved = composite.getChild(1);
  assert(retrieved.name() == "Child2", "Should get second child");
  
  retrieved = composite.getChild(10);
  assert(retrieved is null, "Should return null for invalid index");
}

// Test clear
unittest {
  auto composite = new Composite("Parent");
  composite.add(new Leaf("A", "1"));
  composite.add(new Leaf("B", "2"));
  composite.add(new Leaf("C", "3"));
  
  assert(composite.childCount() == 3, "Should have 3 children");
  
  composite.clear();
  assert(composite.childCount() == 0, "Should have no children after clear");
}

// Test tree operations
unittest {
  auto tree = new Tree("Root");
  tree.add(new Leaf("L1", "A"));
  tree.add(new Leaf("L2", "B"));
  
  auto branch = new Composite("Branch");
  branch.add(new Leaf("L3", "C"));
  tree.add(branch);
  
  assert(tree.nodeCount() == 5, "Should count all nodes");
  assert(tree.depth() == 3, "Should calculate correct depth");
}

// Test find operation
unittest {
  auto tree = new Tree("Root");
  tree.add(new Leaf("Item1", "Value1"));
  
  auto branch = new Composite("Branch");
  branch.add(new Leaf("Item2", "Value2"));
  branch.add(new Leaf("Item3", "Value3"));
  tree.add(branch);
  
  auto found = tree.find("Item2");
  assert(found !is null, "Should find Item2");
  assert(found.name() == "Item2", "Found item should match");
  
  found = tree.find("Branch");
  assert(found !is null, "Should find Branch");
  
  found = tree.find("NonExistent");
  assert(found is null, "Should not find non-existent item");
}

// Test traverse operation
unittest {
  auto composite = new Composite("Root");
  composite.add(new Leaf("A", "1"));
  composite.add(new Leaf("B", "2"));
  
  auto subComposite = new Composite("Sub");
  subComposite.add(new Leaf("C", "3"));
  composite.add(subComposite);
  
  string[] names;
  composite.traverse((component) {
    names ~= component.name();
  });
  
  assert(names.length == 5, "Should visit all components");
  assert(names[0] == "Root", "Should start with root");
}

// Test children method
unittest {
  auto composite = new Composite("Parent");
  auto child1 = new Leaf("C1", "A");
  auto child2 = new Leaf("C2", "B");
  
  composite.add(child1);
  composite.add(child2);
  
  auto children = composite.children();
  assert(children.length == 2, "Should return all children");
  assert(children[0] is child1, "First child should match");
  assert(children[1] is child2, "Second child should match");
  
  // Modify returned array should not affect composite
  children.length = 0;
  assert(composite.childCount() == 2, "Original should be unchanged");
}

// Test null handling
unittest {
  auto composite = new Composite("Test");
  
  composite.add(null);
  assert(composite.childCount() == 0, "Should not add null");
  
  composite.remove(null);
  // Should not crash
}

// Test complex tree structure
unittest {
  auto root = new Tree("FileSystem");
  
  auto documents = new Composite("Documents");
  documents.add(new Leaf("resume.pdf", "Resume content"));
  documents.add(new Leaf("cover.pdf", "Cover letter"));
  
  auto pictures = new Composite("Pictures");
  pictures.add(new Leaf("photo1.jpg", "Photo 1"));
  pictures.add(new Leaf("photo2.jpg", "Photo 2"));
  
  auto vacation = new Composite("Vacation");
  vacation.add(new Leaf("beach.jpg", "Beach photo"));
  pictures.add(vacation);
  
  root.add(documents);
  root.add(pictures);
  
  assert(root.nodeCount() == 10, "Should count all nodes in tree");
  assert(root.depth() == 4, "Should calculate max depth");
  
  auto found = root.find("beach.jpg");
  assert(found !is null, "Should find nested file");
}

// Test value modification
unittest {
  auto leaf = new Leaf("Test", "Original");
  assert(leaf.value() == "Original", "Initial value should match");
  
  leaf.value("Modified");
  assert(leaf.value() == "Modified", "Value should be modified");
  assert(leaf.execute() == "Modified", "Execute should return new value");
}

// Test empty composite
unittest {
  auto composite = new Composite("Empty");
  auto result = composite.execute();
  assert(result == "", "Empty composite should return empty string");
}

// Test single child composite
unittest {
  auto composite = new Composite("Single");
  composite.add(new Leaf("Only", "OnlyValue"));
  
  auto result = composite.execute();
  assert(result == "OnlyValue", "Single child result should not have comma");
}

// Test helper functions
unittest {
  auto leaf = createLeaf("TestLeaf", "TestValue");
  assert(leaf.name() == "TestLeaf");
  assert(leaf.value() == "TestValue");
  
  auto composite = createComposite("TestComposite");
  assert(composite.name() == "TestComposite");
  assert(composite.isComposite());
  
  auto tree = createTree("TestTree");
  assert(tree.name() == "TestTree");
}
