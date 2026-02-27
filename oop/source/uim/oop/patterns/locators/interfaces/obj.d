module uim.oop.patterns.locators.interfaces.obj;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base interface for all objects that can be registered with a Object Locator.
 */
interface ILocatorObject {
  /**
   * Get the name of this object.
   */
  string objectName() @safe;

  /**
   * Execute the object's main operation.
   */
  string execute() @safe;
}