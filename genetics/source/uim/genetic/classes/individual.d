/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.individual;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
  * Represents an individual in the genetic algorithm, encapsulating its genome and fitness value.
  * The genome is represented as an array of unsigned bytes (ubyte[]), and the fitness is a double value.
  * The class provides methods to get and set the genome and fitness, check if the individual has been evaluated, clone itself, and serialize/deserialize to/from JSON.
  * Note: The actual representation of the genome and the calculation of fitness would depend on the specific problem being solved by the genetic algorithm.
  *
  * Example usage:
  * auto ind = new Individual([1, 0, 1, 1]);
  * ind.fitness(0.75);
  * writeln("Genome: ", ind.genome());
  * writeln("Fitness: ", ind.fitness());
  * The individual can be cloned to create a new instance with the same genome and fitness:
  * auto clone = ind.clone();
  * writeln("Cloned Genome: ", clone.genome());
  * writeln("Cloned Fitness: ", clone.fitness());
  * The individual can also be serialized to JSON and deserialized back:
  * Json json = ind.toJson();
  * auto indFromJson = Individual.fromJson(json);
  * writeln("Genome from JSON: ", indFromJson.genome());
  * writeln("Fitness from JSON: ", indFromJson.fitness());
  * Note: The actual implementation of the genetic algorithm components (selection, crossover, mutation) and the population management is simplified for demonstration purposes and may need to be expanded for a real-world application.
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
///
unittest {
  auto ind = new Individual([1, 0, 1, 1]);
  assert(ind.genome() == [1, 0, 1, 1]);
  assert(ind.fitness() == -1.0);
  assert(!ind.isEvaluated());

  ind.fitness(0.75);
  assert(ind.fitness() == 0.75);
  assert(ind.isEvaluated());

  auto clone = ind.clone();
  assert(clone.genome() == ind.genome());
  assert(clone.fitness() == ind.fitness());
  assert(clone.isEvaluated());

  Json json = ind.toJson();
  auto indFromJson = Individual.fromJson(json);
  assert(indFromJson.genome() == ind.genome());
  assert(indFromJson.fitness() == ind.fitness());
  assert(indFromJson.isEvaluated());
}
