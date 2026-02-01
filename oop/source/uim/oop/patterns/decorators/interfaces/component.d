/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
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
