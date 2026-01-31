/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.genetic.interfaces.individual;

import vibe.d;

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
  double fitness() @safe;

  /**
   * Set the fitness score.
   */
  void fitness(double value) @safe;

  /**
   * Get the genome (genetic material) as bytes.
   */
  const(ubyte)[] genome() @safe;

  /**
   * Set the genome.
   */
  void genome(ubyte[] genes) @safe;

  /**
   * Get genome length in bits/bytes.
   */
  size_t genomeLength() @safe;

  /**
   * Check if fitness has been evaluated.
   */
  bool isEvaluated() @safe;

  /**
   * Clone this individual.
   */
  IIndividual clone() @safe;

  /**
   * Get individual as Json for serialization.
   */
  Json toJson() @safe;

  /**
   * Create individual from Json.
   */
  static IIndividual fromJson(Json data) @safe;
}
