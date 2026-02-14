/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.pmx;

import uim.genetic;
import std.random : uniform;

mixin(ShowModule!());

@safe:

/**
 * Partially mapped crossover (PMX) for permutations.
 */
class PMXCrossover : ICrossoverOperator {
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

    bool[256] inSegment1;
    bool[256] inSegment2;
    ubyte[256] map12;
    ubyte[256] map21;
    bool[256] hasMap12;
    bool[256] hasMap21;

    foreach (i; point1 .. point2) {
      ubyte g1 = genes1[i];
      ubyte g2 = genes2[i];
      child1[i] = g1;
      child2[i] = g2;
      inSegment1[g1] = true;
      inSegment2[g2] = true;
      map12[g1] = g2;
      map21[g2] = g1;
      hasMap12[g1] = true;
      hasMap21[g2] = true;
    }

    foreach (i; 0 .. length) {
      if (i >= point1 && i < point2) continue;

      ubyte gene1 = genes2[i];
      while (hasMap12[gene1] && inSegment1[gene1]) {
        gene1 = map12[gene1];
      }
      child1[i] = gene1;

      ubyte gene2 = genes1[i];
      while (hasMap21[gene2] && inSegment2[gene2]) {
        gene2 = map21[gene2];
      }
      child2[i] = gene2;
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
