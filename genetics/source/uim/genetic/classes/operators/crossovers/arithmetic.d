/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.arithmetic;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Arithmetic crossover operator for real-valued genes encoded as bytes.
 */
class ArithmeticCrossover : ICrossoverOperator {
  protected double _rate = 0.7;
  protected double _alpha = 0.5;

  this() {
  }

  this(double rate) {
    _rate = rate;
  }

  this(double rate, double alpha) {
    _rate = rate;
    _alpha = alpha;
  }

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
    double alpha = _alpha;

    foreach (i; 0 .. child1.length) {
      double g1 = cast(double) child1[i];
      double g2 = cast(double) child2[i];
      child1[i] = clampUbyte(alpha * g1 + (1.0 - alpha) * g2);
      child2[i] = clampUbyte(alpha * g2 + (1.0 - alpha) * g1);
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

  double alpha() {
    return _alpha;
  }

  void alpha(double value) {
    _alpha = value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value);
  }

  private static ubyte clampUbyte(double value) {
    if (value < 0.0) return 0;
    if (value > 255.0) return 255;
    return cast(ubyte)(value + 0.5);
  }
}
