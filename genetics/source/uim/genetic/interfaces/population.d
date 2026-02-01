/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.interfaces.population;

import uim.genetic;

@safe:

/**
 * Represents a population of individuals in a genetic algorithm.
 */
interface IPopulation {
  /**
   * Get population size.
   */
  size_t size() @safe;

  /**
   * Add an individual to the population.
   */
  void add(IIndividual individual) @safe;

  /**
   * Get individual by index.
   */
  IIndividual get(size_t index) @safe;

  /**
   * Get all individuals.
   */
  const(IIndividual)[] individuals() @safe;

  /**
   * Get the best individual.
   */
  IIndividual best() @safe;

  /**
   * Get the worst individual.
   */
  IIndividual worst() @safe;

  /**
   * Get average fitness.
   */
  double averageFitness() @safe;

  /**
   * Sort population by fitness (descending).
   */
  void sort() @safe;

  /**
   * Clear population.
   */
  void clear() @safe;

  /**
   * Get population statistics as Json.
   */
  Json statistics() @safe;
}
