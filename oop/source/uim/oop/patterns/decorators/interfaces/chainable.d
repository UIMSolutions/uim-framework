module uim.oop.patterns.decorators.interfaces.chainable;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Interface for decorators that can be chained.
 */
interface IChainableDecorator : IDecorator {
  /**
   * Add another decorator to the chain.
   * Params:
   *   decorator = The decorator to add
   * Returns: The decorator chain
   */
  IChainableDecorator addDecorator(IDecorator decorator);

  /**
   * Get the number of decorators in the chain.
   * Returns: The chain length
   */
  size_t chainLength();
}