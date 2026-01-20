/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.decorators.functional;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Functional decorator that applies a function before/after execution.
 */
class FunctionalDecorator : Decorator {
  private string delegate() @safe _beforeFunc;
  private string delegate() @safe _afterFunc;

  /**
   * Create a functional decorator.
   * Params:
   *   component = The component to decorate
   *   beforeFunc = Function to execute before the component
   *   afterFunc = Function to execute after the component
   */
  this(IDecoratorComponent component, 
       string delegate() @safe beforeFunc = null,
       string delegate() @safe afterFunc = null) {
    super(component);
    _beforeFunc = beforeFunc;
    _afterFunc = afterFunc;
  }

  /**
   * Execute with before and after hooks.
   * Returns: Combined result
   */
  override string execute() {
    string result = "";
    
    if (_beforeFunc) {
      result ~= _beforeFunc();
    }
    
    result ~= super.execute();
    
    if (_afterFunc) {
      result ~= _afterFunc();
    }
    
    return result;
  }
}
