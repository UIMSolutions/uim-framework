/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossover;

import uim.genetic;
import std.random : uniform;

@safe:

/**
 * Single-point crossover operator.
 */
class SinglePointCrossover : ICrossoverOperator {
  protected double _rate = 0.7;

  this() {
  }

  this(double rate) {
    _rate = rate;
  }

  override IIndividual[] crossover(IIndividual parent1, IIndividual parent2) {
    IIndividual[] offspring;

    if (uniform(0.0, 1.0) > _rate) {
      // No crossover, return clones
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    if (parent1.genomeLength() == 0 || parent2.genomeLength() == 0) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    size_t crossoverPoint = uniform(1, parent1.genomeLength());
    
    auto gene1 = parent1.genome().dup;
    auto gene2 = parent2.genome().dup;

    // Swap genes after crossover point
    auto temp = gene1[crossoverPoint..$].dup;
    gene1[crossoverPoint..$] = gene2[crossoverPoint..$];
    gene2[crossoverPoint..$] = temp;

    auto child1 = new Individual(gene1);
    auto child2 = new Individual(gene2);

    offspring ~= child1;
    offspring ~= child2;

    return offspring;
  }

  override double rate() {
    return _rate;
  }

  override void rate(double value) {
    _rate = value;
  }
}

/**
 * Two-point crossover operator.
 */
class TwoPointCrossover : ICrossoverOperator {
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

    if (parent1.genomeLength() < 2) {
      offspring ~= parent1.clone();
      offspring ~= parent2.clone();
      return offspring;
    }

    size_t point1 = uniform(0, parent1.genomeLength() - 1);
    size_t point2 = uniform(point1 + 1, parent1.genomeLength());

    auto gene1 = parent1.genome().dup;
    auto gene2 = parent2.genome().dup;

    // Swap genes between two points
    auto temp = gene1[point1..point2].dup;
    gene1[point1..point2] = gene2[point1..point2];
    gene2[point1..point2] = temp;

    offspring ~= new Individual(gene1);
    offspring ~= new Individual(gene2);

    return offspring;
  }

  override double rate() {
    return _rate;
  }

  override void rate(double value) {
    _rate = value;
  }
}
