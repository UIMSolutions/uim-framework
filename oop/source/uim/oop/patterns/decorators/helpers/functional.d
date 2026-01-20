/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.decorators.helpers.functional;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Helper function to create a functional decorator.
 */
FunctionalDecorator createFunctionalDecorator(
    IDecoratorComponent component,
    string delegate() @safe beforeFunc = null,
    string delegate() @safe afterFunc = null) {
  return new FunctionalDecorator(component, beforeFunc, afterFunc);
}