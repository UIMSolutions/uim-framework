/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.evaluators.simple;

import uim.genetic;

@safe:

/**
 * Simple fitness evaluator for testing.
 * Evaluates how close a genome is to a target pattern.
 */
class SimplePatternMatcher : IFitnessEvaluator {
  protected ubyte[] _targetPattern;

  this(ubyte[] target) {
    _targetPattern = target.dup;
  }

  override void evaluate(IIndividual individual, 
    void delegate(double fitness) @safe callback) @trusted {
    
    auto genome = individual.genome();
    if (genome.length != _targetPattern.length) {
      callback(0.0);
      return;
    }

    size_t matches = 0;
    foreach (i, gene; genome) {
      if (gene == _targetPattern[i]) {
        matches++;
      }
    }

    double fitness = cast(double)matches / genome.length;
    callback(fitness);
  }

  override void evaluatePopulation(IIndividual[] individuals,
    void delegate(IIndividual[]) @safe callback) @trusted {
    
    // For demonstration, evaluate sequentially
    foreach (ind; individuals) {
      evaluate(ind, (double fit) {
        ind.fitness(fit);
      });
    }
    callback(individuals);
  }
}