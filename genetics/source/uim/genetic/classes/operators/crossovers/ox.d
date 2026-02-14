/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.ox;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Order crossover (OX) for permutations.
 */
class OXCrossover : ICrossoverOperator {
  protected double _rate = 0.7;

  this() {
  }

  this(double rate) {
    _rate = rate;
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

    if (!isSameLength(parent1, parent2)) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    auto genes1 = parent1.genome();
    auto genes2 = parent2.genome();
    if (!isUniquePermutation(genes1) || !isUniquePermutation(genes2) || !hasSameGeneSet(genes1, genes2)) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    size_t length = genes1.length;
    size_t point1 = uniform(0, length - 1);
    size_t point2 = uniform(point1 + 1, length);

    auto child1 = new ubyte[length];
    auto child2 = new ubyte[length];
    bool[256] used1;
    bool[256] used2;
    bool[] filledPos1 = new bool[length];
    bool[] filledPos2 = new bool[length];

    foreach (i; point1 .. point2) {
      child1[i] = genes1[i];
      child2[i] = genes2[i];
      used1[genes1[i]] = true;
      used2[genes2[i]] = true;
      filledPos1[i] = true;
      filledPos2[i] = true;
    }

    size_t fillIndex1 = point2 % length;
    size_t fillIndex2 = point2 % length;

    foreach (offset; 0 .. length) {
      size_t idx = (point2 + offset) % length;
      ubyte g2 = genes2[idx];
      if (!used1[g2]) {
        while (filledPos1[fillIndex1]) {
          fillIndex1 = (fillIndex1 + 1) % length;
        }
        child1[fillIndex1] = g2;
        used1[g2] = true;
        filledPos1[fillIndex1] = true;
        fillIndex1 = (fillIndex1 + 1) % length;
      }

      ubyte g1 = genes1[idx];
      if (!used2[g1]) {
        while (filledPos2[fillIndex2]) {
          fillIndex2 = (fillIndex2 + 1) % length;
        }
        child2[fillIndex2] = g1;
        used2[g1] = true;
        filledPos2[fillIndex2] = true;
        fillIndex2 = (fillIndex2 + 1) % length;
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
