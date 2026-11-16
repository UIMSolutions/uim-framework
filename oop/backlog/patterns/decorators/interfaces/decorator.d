module uim.oop.patterns.decorators.interfaces.decorator;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Decorator interface that wraps a component.
 */
interface IDecorator : IDecoratorComponent {
  /**
   * Get the wrapped component.
   * Returns: The component being decorated
   */
  IDecoratorComponent component();

  /**
   * Set the wrapped component.
   * Params:
   *   comp = The component to wrap
   */
  void component(IDecoratorComponent comp);
}