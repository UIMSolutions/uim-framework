module uim.oop.patterns.decorators.interfaces.component;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Base component interface for the Decorator pattern.
 * Components can be decorated with additional behavior.
 */
interface IDecoratorComponent {
  /**
   * Execute the component's operation.
   * Returns: Result of the operation
   */
  string execute();
}