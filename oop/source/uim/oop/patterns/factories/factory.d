/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.factories.factory;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Simple factory implementation using a delegate.
 * Supports both direct creation and registry-based creation by key.
 */
class UIMFactory(K, V) : IFactory!(K, V) {
  private V delegate() @safe _defaultCreator;
  protected V delegate()[K] _creators;

  this(V delegate() @safe creator) { // Constructor with default creator
    _defaultCreator = creator;
  }

  /** 
   * Creates and returns an instance using the default creator.
   * 
   * Returns:
   *     An instance of type V.
   */
  V create() {
    return _defaultCreator();
  }

  /** 
     * Creates and returns an instance of type T.
     * 
     * Params:
     *     K key = The key associated with the object to be created.
     * 
     * Returns:
     *     An instance of type T.
     */
  V create(K key) {
    return isRegistered(key) ? _creators[key]() : null;
  }

  /** 
     * Registers a creator function for a specific key.
     * 
     * Params:
     *     K key = The key to register the creator function under.
     *     V delegate() @safe creator = The creator function that returns an instance of type V.
     * 
     * Returns:
     *     The factory instance for method chaining.
     */
  IFactory!(K, V) register(K key, V delegate() @safe creator) {
    _creators[key] = creator;
    return this;
  }

  /** 
     * Checks if a key is registered in the factory.
     * 
     * Params:
     *     K key = The key to check for registration.
     * 
     * Returns:
     *     true if the key is registered, false otherwise.
     */
  bool isRegistered(K key) {
    return key in _creators ? true : false;
  }

  /** 
     * Unregisters a key from the factory.
     * 
     * Params:
     *     K key = The key to unregister.
     * 
     * Returns:
     *     The factory instance for method chaining.
     */
  IFactory!(K, V) unregister(K key) {
    _creators.remove(key);
    return this;
  }

  /** 
     * Gets all registered keys in the factory.
     * 
     * Returns:
     *     An array of registered keys.
     */
  string[] registeredKeys() {
    return _creators.keys;
  }

  /** 
     * Clears all registered keys from the factory.
     * 
     * Returns:
     *     The factory instance for method chaining.
     */
  IFactory!(K, V) clearRegistry() {
    _creators.clear();
    return this;
  }
}
///
unittest {
  mixin(ShowTest!"Testing Factory Pattern");

  class Product {
    int value;
    this(int v) { value = v; }
  }

  auto factory = new UIMFactory!(string, Product)(() => new Product(0));

  factory
    .register("A", () => new Product(1))
    .register("B", () => new Product(2))
    .register("C", () => new Product(3));

  auto productA = factory.create("A");
  auto productB = factory.create("B");
  auto productC = factory.create("C");
  auto defaultProduct = factory.create();

  assert(productA !is null && productA.value == 1, "Product A creation failed");
  assert(productB !is null && productB.value == 2, "Product B creation failed");
  assert(productC !is null && productC.value == 3, "Product C creation failed");
  assert(defaultProduct !is null && defaultProduct.value == 0, "Default product creation failed");
}