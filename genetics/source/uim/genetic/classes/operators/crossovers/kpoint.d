/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.kpoint;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * K-point crossover operator.
 */
class KPunktCrossover : ICrossoverOperator {
  protected double _rate = 0.7;
  protected size_t _k = 3;

  this() {
  }

  this(double rate) {
    _rate = rate;
  }

  this(double rate, size_t k) {
    _rate = rate;
    _k = k;
  }

  override IIndividual[] crossover(IIndividual parent1, IIndividual parent2) {
    IIndividual[] offspring;

    if (uniform(0.0, 1.0) > _rate) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    if (parent1.genomeLength() < 2 || parent2.genomeLength() < 2) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    if (parent1.genomeLength() != parent2.genomeLength()) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    size_t length = parent1.genomeLength();
    size_t k = _k;
    if (k >= length) k = length - 1;
    if (k == 0) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    bool[] used = new bool[length];
    size_t[] points;
    while (points.length < k) {
      size_t point = uniform(1, length);
      if (!used[point]) {
        used[point] = true;
        points ~= point;
      }
    }

    import std.algorithm : sort;
    sort(points);

    auto child1 = parent1.genome().dup;
    auto child2 = parent2.genome().dup;

    size_t last = 0;
    bool swapSegment = false;
    foreach (point; points) {
      if (swapSegment) {
        auto temp = child1[last..point].dup;
        child1[last..point] = child2[last..point];
        child2[last..point] = temp;
      }
      swapSegment = !swapSegment;
      last = point;
    }

    if (swapSegment) {
      auto temp = child1[last..$].dup;
      child1[last..$] = child2[last..$];
      child2[last..$] = temp;
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

  size_t k() {
    return _k;
  }

  void k(size_t value) {
    _k = value;
  }
}
