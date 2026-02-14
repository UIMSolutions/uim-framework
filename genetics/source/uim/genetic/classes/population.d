/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.population;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Basic population implementation.
 */
class Population : IPopulation {
  protected IIndividual[] _individuals;

  this() {
  }

  this(IIndividual[] individuals) {
    _individuals = individuals.dup;
  }

  override size_t size() {
    return _individuals.length;
  }

  override void add(IIndividual individual) {
    _individuals ~= individual;
  }

  override IIndividual get(size_t index) {
    if (index < _individuals.length) {
      return _individuals[index];
    }
    return null;
  }

  override const(IIndividual)[] individuals() {
    return cast(const) _individuals;
  }

  override IIndividual best() {
    if (_individuals.length == 0) return null;
    IIndividual best = _individuals[0];
    foreach (ind; _individuals[1..$]) {
      if (ind.fitness() > best.fitness()) {
        best = ind;
      }
    }
    return best;
  }

  override IIndividual worst() {
    if (_individuals.length == 0) return null;
    IIndividual worst = _individuals[0];
    foreach (ind; _individuals[1..$]) {
      if (ind.fitness() < worst.fitness()) {
        worst = ind;
      }
    }
    return worst;
  }

  override double averageFitness() {
    if (_individuals.length == 0) return 0.0;
    double sum = 0.0;
    foreach (ind; _individuals) {
      sum += ind.fitness();
    }
    return sum / _individuals.length;
  }

  override void sort() {
    // Sort by fitness descending
    import std.algorithm : sort;
    std.algorithm.sort!((a, b) => a.fitness() > b.fitness())(_individuals);
  }

  override void clear() {
    _individuals = [];
  }

  override Json statistics() {
    Json stats;
    if (_individuals.length > 0) {
      sort();
      stats["size"] = Json(_individuals.length);
      stats["best"] = Json(best().fitness());
      stats["worst"] = Json(worst().fitness());
      stats["average"] = Json(averageFitness());
    }
    return stats;
  }
}
