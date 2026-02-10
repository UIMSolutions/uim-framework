/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.interfaces.individual;

import uim.genetic;

@safe:

/**
 * Represents a single individual in a genetic algorithm population.
 * An individual encodes a potential solution to the optimization problem.
 */
interface IIndividual {
  /**
   * Get the fitness score of this individual.
   * Higher values represent better solutions.
   */
  double fitness();

  /**
   * Set the fitness score.
   */
  void fitness(double value);

  /**
   * Get the genome (genetic material) as bytes.
   */
  const(ubyte)[] genome();

  /**
   * Set the genome.
   */
  void genome(ubyte[] genes);

  /**
   * Get genome length in bits/bytes.
   */
  size_t genomeLength();

  /**
   * Check if fitness has been evaluated.
   */
  bool isEvaluated();

  /**
   * Clone this individual.
   */
  IIndividual clone();

  /**
   * Get individual as Json for serialization.
   */
  Json toJson();

  /**
   * Create individual from Json.
   */
  static IIndividual fromJson(Json data);
}
