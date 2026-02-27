/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.evaluators.numerical;

import uim.genetic;

@safe:

/**
  * A fitness evaluator that optimizes a numerical function. It converts the individual's genome (a byte array) into a numerical value and evaluates it using a provided function.
  * The fitness is calculated based on the output of the function, which can be designed to maximize or minimize the value as needed.
  * This class implements the IFitnessEvaluator interface, allowing it to be used in the genetic algorithm framework for evaluating individuals and populations.
  *
  * Example usage:
  * auto optimizer = new NumericalOptimizer((double x) => -x*x + 4*x); // Maximize the function -x^2 + 4x
  * auto ind = new Individual([128]); // Genome representing a value around 0.5
  * optimizer.evaluate(ind, (double fitness) {
  *   writeln("Fitness: ", fitness);
  * });
  *
  * In this example, the individual's genome is converted to a numerical value, which is then evaluated using the provided function. The fitness is printed to the console.
  * Note: The actual implementation of the genetic algorithm components (selection, crossover, mutation) and the population management is simplified for demonstration purposes and may need to be expanded for a real-world application.
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
      evaluate(ind, (double fit) {
        ind.fitness(fit);
      });
    }
    callback(individuals);
  }
}
