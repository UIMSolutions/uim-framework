/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.genetic.interfaces.fitness;

import uim.genetic;

@safe:

/**
 * Fitness evaluator interface for determining individual quality.
 */
interface IFitnessEvaluator {
  /**
   * Evaluate an individual asynchronously.
   */
  void evaluate(IIndividual individual, void delegate(double fitness) @safe callback) @trusted;

  /**
   * Evaluate multiple individuals in parallel asynchronously.
   */
  void evaluatePopulation(IIndividual[] individuals, 
    void delegate(IIndividual[]) @safe callback) @trusted;
}
