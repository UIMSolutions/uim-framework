/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
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