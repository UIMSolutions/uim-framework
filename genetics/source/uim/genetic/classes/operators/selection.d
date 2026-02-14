/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.selection;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Roulette wheel selection strategy.
 */
class RouletteWheelSelection : ISelectionStrategy {
  override IIndividual select(IPopulation population) {
    if (population.size() == 0) return null;

    double totalFitness = 0.0;
    foreach (individual; population.individuals()) {
      if (individual.fitness() >= 0) {
        totalFitness += individual.fitness();
      }
    }

    if (totalFitness <= 0) {
      // Random selection if all fitness is negative
      return population.get(uniform(0, population.size()));
    }

    double spin = uniform(0.0, totalFitness);
    double accumulated = 0.0;

    foreach (individual; population.individuals()) {
      accumulated += individual.fitness();
      if (accumulated >= spin) {
        return individual;
      }
    }

    return population.individuals()[$ - 1];
  }

  override IIndividual[] selectMultiple(IPopulation population, size_t count) {
    IIndividual[] selected;
    for (size_t i = 0; i < count; i++) {
      selected ~= select(population);
    }
    return selected;
  }
}

/**
 * Tournament selection strategy.
 */

/**
 * Rank-based selection strategy.
 */
class RankSelection : ISelectionStrategy {
  override IIndividual select(IPopulation population) {
    if (population.size() == 0) return null;

    auto individuals = population.individuals().dup;
    import std.algorithm : sort;
    std.algorithm.sort!((a, b) => a.fitness() > b.fitness())(individuals);

    // Rank-based weights: higher rank = higher probability
    double totalWeight = 0.0;
    for (size_t i = 0; i < individuals.length; i++) {
      totalWeight += (cast(double)(i + 1));
    }

    double spin = uniform(0.0, totalWeight);
    double accumulated = 0.0;

    for (size_t i = 0; i < individuals.length; i++) {
      accumulated += (cast(double)(i + 1));
      if (accumulated >= spin) {
        return individuals[i];
      }
    }

    return individuals[$ - 1];
  }

  override IIndividual[] selectMultiple(IPopulation population, size_t count) {
    IIndividual[] selected;
    for (size_t i = 0; i < count; i++) {
      selected ~= select(population);
    }
    return selected;
  }
}
