/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.evaluators.simple;

import uim.genetic;

@safe:

/** 
  * A simple fitness evaluator that compares an individual's genome to a target pattern and calculates fitness based on the number of matching genes.
  * The fitness is calculated as the ratio of matching genes to the total length of the genome, resulting in a value between 0.0 and 1.0.
  * This class implements the IFitnessEvaluator interface, allowing it to be used in the genetic algorithm framework for evaluating individuals and populations.
  *
  * Example usage:
  * auto target = [1, 0, 1, 1];
  * auto matcher = new SimplePatternMatcher(target);
  * auto ind = new Individual([1, 0, 0, 1]);
  * matcher.evaluate(ind, (double fitness) {
  *   writeln("Fitness: ", fitness);
  * });
  *
  * In this example, the individual's genome is compared to the target pattern, and the fitness is calculated based on the number of matching genes. The fitness is printed to the console.
  * Note: The actual implementation of the genetic algorithm components (selection, crossover, mutation) and the population management is simplified for demonstration purposes and may need to be expanded for a real-world application.
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