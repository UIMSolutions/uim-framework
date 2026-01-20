/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.decorators.chainable;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Chainable decorator that supports multiple decorators.
 */
class ChainableDecorator : Decorator, IChainableDecorator {
  private IDecorator[] _decoratorChain;

  /**
   * Create a chainable decorator.
   * Params:
   *   component = The component to decorate
   */
  this(IDecoratorComponent component) {
    super(component);
  }

  /**
   * Add another decorator to the chain.
   * Params:
   *   decorator = The decorator to add
   * Returns: This decorator for chaining
   */
  IChainableDecorator addDecorator(IDecorator decorator) {
    if (decorator !is null) {
      _decoratorChain ~= decorator;
    }
    return this;
  }

  /**
   * Get the number of decorators in the chain.
   * Returns: The chain length
   */
  size_t chainLength() {
    return _decoratorChain.length;
  }

  /**
   * Execute all decorators in the chain.
   * Returns: Combined result of all decorations
   */
  override string execute() {
    string result = super.execute();
    
    foreach (decorator; _decoratorChain) {
      decorator.component(_component);
      result ~= " " ~ decorator.execute();
    }
    
    return result;
  }
}
