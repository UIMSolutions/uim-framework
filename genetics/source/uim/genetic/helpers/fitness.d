/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.genetic.helpers.fitness;

import uim.genetic.interfaces;
import vibe.d;

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
      evaluate(ind, (double fit) @safe {
        ind.fitness(fit);
      });
    }
    callback(individuals);
  }
}

/**
 * Fitness evaluator for numerical optimization.
 * Evaluates genome as binary representation of a number.
 */
class NumericalOptimizer : IFitnessEvaluator {
  protected double delegate(double) @safe _function;

  this(double delegate(double) @safe f) {
    _function = f;
  }

  override void evaluate(IIndividual individual,
    void delegate(double fitness) @safe callback) @trusted {
    
    auto genome = individual.genome();
    if (genome.length == 0) {
      callback(0.0);
      return;
    }

    // Convert bytes to a number (0.0 to 1.0)
    double value = 0.0;
    foreach (i, gene; genome) {
      value += cast(double)gene / (256.0 * (i + 1));
    }

    double fitness = _function(value);
    callback(fitness);
  }

  override void evaluatePopulation(IIndividual[] individuals,
    void delegate(IIndividual[]) @safe callback) @trusted {
    
    foreach (ind; individuals) {
      evaluate(ind, (double fit) @safe {
        ind.fitness(fit);
      });
    }
    callback(individuals);
  }
}
