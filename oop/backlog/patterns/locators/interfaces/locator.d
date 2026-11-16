/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.locators.interfaces.locator;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for Object Locator pattern.
 * Provides centralized registry for obtaining objects.
 */
interface ILocator {
  /**
   * Register a object with the locator.
   * Params:
   *   name = The name to register the object under
   *   object = The object instance to register
   */
  void registerObject(string name, ILocatorObject obj) @safe;

  /**
   * Get a object by name.
   * Params:
   *   name = The name of the object to retrieve
   * Returns: The object instance, or null if not found
   */
  ILocatorObject getObject(string name) @safe;

  /**
   * Check if a object is registered.
   * Params:
   *   name = The name of the object to check
   * Returns: true if the object is registered, false otherwise
   */
  bool hasObject(string name) @safe;

  /**
   * Unregister a object.
   * Params:
   *   name = The name of the object to unregister
   * Returns: true if the object was unregistered, false if it wasn't found
   */
  bool unregisterObject(string name) @safe;

  /**
   * Get all registered object names.
   * Returns: Array of object names
   */
  string[] getObjectNames() @safe;

  /**
   * Clear all registered objects.
   */
  void clear() @safe;
}