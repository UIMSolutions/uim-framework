/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.uniform;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Uniform crossover operator.
 */
class UniformCrossover : ICrossoverOperator {
  protected double _rate = 0.7;

  this() {
  }

  this(double rate) {
    _rate = rate;
  }

  // Crossover two parents to produce two offspring
  override IIndividual[] crossover(IIndividual parent1, IIndividual parent2) {
    IIndividual[] offspring;

    if (uniform(0.0, 1.0) > _rate) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    if (parent1.genomeLength() == 0 || parent2.genomeLength() == 0) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    if (parent1.genomeLength() != parent2.genomeLength()) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    auto child1 = parent1.genome().dup;
    auto child2 = parent2.genome().dup;

    foreach (i; 0 .. child1.length) {
      if (uniform(0.0, 1.0) < 0.5) {
        auto temp = child1[i];
        child1[i] = child2[i];
        child2[i] = temp;
      }
    }

    offspring ~= new Individual(child1);
    offspring ~= new Individual(child2);

    return offspring;
  }

  override double rate() {
    return _rate;
  }

  override void rate(double value) {
    _rate = value;
  }
}
