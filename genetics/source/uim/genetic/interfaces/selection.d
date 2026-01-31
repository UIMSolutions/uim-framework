/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.genetic.interfaces.selection;

import uim.genetic;

@safe:

/**
 * Selection strategy for choosing individuals for reproduction.
 */
interface ISelectionStrategy {
  /**
   * Select an individual from the population.
   */
  IIndividual select(IPopulation population) @safe;

  /**
   * Select multiple individuals.
   */
  IIndividual[] selectMultiple(IPopulation population, size_t count) @safe;
}
