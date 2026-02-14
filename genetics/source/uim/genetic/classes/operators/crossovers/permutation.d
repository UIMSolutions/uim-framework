/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.permutation;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Permutation crossover using cycle crossover (CX).
 */
class PermutationCrossover : ICrossoverOperator {
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
    size_t startIndex = uniform(0, length);

    size_t[256] index1;
    bool[256] hasIndex1;
    foreach (i; 0 .. length) {
      index1[genes1[i]] = i;
      hasIndex1[genes1[i]] = true;
    }

    bool[] inCycle = new bool[length];
    size_t index = startIndex;
    while (!inCycle[index]) {
      inCycle[index] = true;
      ubyte value = genes2[index];
      if (!hasIndex1[value]) break;
      index = index1[value];
    }

    auto child1 = new ubyte[length];
    auto child2 = new ubyte[length];

    foreach (i; 0 .. length) {
      if (inCycle[i]) {
        child1[i] = genes1[i];
        child2[i] = genes2[i];
      } else {
        child1[i] = genes2[i];
        child2[i] = genes1[i];
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
