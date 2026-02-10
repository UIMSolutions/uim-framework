/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.individual;

import uim.genetic;

@safe:

/**
 * Base implementation of a genetic individual.
 */
class Individual : IIndividual {
  protected ubyte[] _genome;
  protected double _fitness = -1.0;
  protected bool _evaluated = false;

  this() {
  }

  this(size_t genomeLength) {
    _genome = new ubyte[genomeLength];
  }

  this(ubyte[] genome) {
    _genome = genome.dup;
  }

  override double fitness() {
    return _fitness;
  }

  override void fitness(double value) {
    _fitness = value;
    _evaluated = true;
  }

  override const(ubyte)[] genome() {
    return _genome;
  }

  override void genome(ubyte[] genes) {
    _genome = genes.dup;
    _evaluated = false;
  }

  override size_t genomeLength() {
    return _genome.length;
  }

  override bool isEvaluated() {
    return _evaluated;
  }

  override IIndividual clone() {
    auto result = new Individual(_genome.dup);
    result._fitness = _fitness;
    result._evaluated = _evaluated;
    return result;
  }

  override Json toJson() {
    Json result;
    result["genome"] = _genome.toJson;
    result["fitness"] = _fitness.toJson;
    result["evaluated"] = _evaluated.toJson;
    return result;
  }

  static IIndividual fromJson(Json data) {
    auto ind = new Individual();
    if (data.hasKey("genome")) {
      ubyte[] genes;
      foreach (val; data["genome"].get!(Json[])) {
        genes ~= cast(ubyte) val.get!long;
      }
      ind.genome(genes);
    }
    if (data.hasKey("fitness")) {
      ind.fitness(data["fitness"].get!double);
    }
    return ind;
  }
}
