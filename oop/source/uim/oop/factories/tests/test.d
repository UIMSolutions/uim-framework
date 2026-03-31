/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.factories.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Tests the factory interface.
 * 
 * @param factory The factory to test.
 * @param instanceName The expected name of the factory instance.
 * @return true if the test passes, false otherwise.
 */
bool testFactory(T)(IFactory!T factory, string instanceName) {
  assert(factory is null, "Factory is null!");
  assert(factory.name == instanceName, "Factory name " ~ instanceName ~ " does not match!");

  // Create an instance and check its type
  auto instance = factory.create();
  assert(instance is T, "Created instance is not of type " ~ T.stringof);

  // Test registration and creation with key
  factory.register("test", () => new T());
  assert(factory.isRegistered("test"), "Factory should have 'test' registered!");
  auto instance2 = factory.create("test", null);
  assert(instance2 is T, "Created instance with key 'test' is not of type " ~ T.stringof);

  // Test creation with key and init data
  Json initData = ["key": "value"];
  auto instance3 = factory.create("test", initData);
  assert(instance3 is T, "Created instance with key 'test' and init data is not of type " ~ T.stringof);

  // Test creation with key and init data as map
  auto instance4 = factory.create("test", initData.toMap);
  assert(instance4 is T, "Created instance with key 'test' and init data as map is not of type " ~ T.stringof);

  // Test creation with key and init data as null
  auto instance5 = factory.create("test", null);
  assert(instance5 is T, "Created instance with key 'test' and null init data is not of type " ~ T.stringof);

  // Test creation with key and init data as empty map
  auto instance6 = factory.create("test", new Json());
  assert(instance6 is T, "Created instance with key 'test' and empty init data is not of type " ~ T.stringof);

  // Test creation with key and init data as non-object JSON
  auto instance7 = factory.create("test", new Json("string"));
  assert(instance7 is T, "Created instance with key 'test' and non-object init data is not of type " ~ T.stringof);

  // Test creation with unregistered key
  try {
    factory.create("unregistered", null);
    assert(false, "Creating with unregistered key should throw an exception!");
  } catch (Exception e) {
    assert(e.message == "No creator registered for key: unregistered", "Unexpected exception message: " ~ e.message);
  }

  // Test isRegistered with unregistered key
  assert(!factory.isRegistered("unregistered"), "Factory should not have 'unregistered' registered!");  

  // Test isRegistered with null key
  try {
    factory.isRegistered(null);
    assert(false, "Checking registration with null key should throw an exception!");
  } catch (Exception e) {
    assert(e.message == "Key cannot be null", "Unexpected exception message: " ~ e.message);
  } 

  // Test register with null key
  try {
    factory.register(null, () => new T());
    assert(false, "Registering with null key should throw an exception!");
  } catch (Exception e) {
    assert(e.message == "Key cannot be null", "Unexpected exception message: " ~ e.message);
  } 

  // Test register with null creator
  try {
    factory.register("nullCreator", null);
    assert(false, "Registering with null creator should throw an exception!");
  } catch (Exception e) {
    assert(e.message == "Creator cannot be null", "Unexpected exception message: " ~ e.message);
  }

  // If we reach this point, all tests passed

  return true;
}
