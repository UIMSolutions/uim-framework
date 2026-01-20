module uim.oop.patterns.factories.interfaces.factory;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Factory interface for creating objects.
 */
interface IFactory(K, V) {
  /** 
   * Creates and returns an instance using the default creator.
   * 
   * Returns:
   *     An instance of type V.
   */
  V create();

  /** 
     * Creates and returns an instance of type T.
     * 
     * Params:
     *     K key = The key associated with the object to be created.
     * 
     * Returns:
     *     An instance of type T.
     */
  V create(K key);

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
  IFactory!(K, V) register(K key, V delegate() @safe creator);

  /** 
     * Checks if a key is registered in the factory.
     * 
     * Params:
     *     K key = The key to check for registration.
     * 
     * Returns:
     *     true if the key is registered, false otherwise.
     */
  bool isRegistered(K key);

  /** 
     * Unregisters a key from the factory.
     * 
     * Params:
     *     K key = The key to unregister.
     * 
     * Returns:
     *     The factory instance for method chaining.
     */
  IFactory!(K, V) unregister(K key);

  /** 
     * Gets all registered keys in the factory.
     * 
     * Returns:
     *     An array of registered keys.
     */
  string[] registeredKeys();

  /** 
     * Clears all registered keys from the factory.
     * 
     * Returns:
     *     The factory instance for method chaining.
     */
  IFactory!(K, V) clearRegistry();
}
