/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.genetic.interfaces.operators;

import uim.genetic.interfaces.individual;

@safe:

/**
 * Crossover operator for combining genetic material from two parents.
 */
interface ICrossoverOperator {
  /**
   * Create offspring by crossing two parents.
   */
  IIndividual[] crossover(IIndividual parent1, IIndividual parent2) @safe;

  /**
   * Get crossover rate (0.0 to 1.0).
   */
  double rate() @safe;

  /**
   * Set crossover rate.
   */
  void rate(double value) @safe;
}

/**
 * Mutation operator for introducing random changes to genome.
 */
interface IMutationOperator {
  /**
   * Mutate an individual.
   */
  void mutate(IIndividual individual) @safe;

  /**
   * Get mutation rate (0.0 to 1.0).
   */
  double rate() @safe;

  /**
   * Set mutation rate.
   */
  void rate(double value) @safe;
}
