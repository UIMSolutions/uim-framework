/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.algorithm;

import uim.genetic;

@safe:

/**
 * Main genetic algorithm implementation with async support.
 */
class GeneticAlgorithm {
  protected IPopulation _population;
  protected IFitnessEvaluator _fitnessEvaluator;
  protected ISelectionStrategy _selectionStrategy;
  protected ICrossoverOperator _crossoverOperator;
  protected IMutationOperator _mutationOperator;
  protected size_t _generation = 0;
  protected size_t _maxGenerations = 100;
  protected double _targetFitness = double.max;
  protected bool _running = false;

  this() {
    _population = new Population();
    _selectionStrategy = new TournamentSelection(3);
    _crossoverOperator = new SinglePointCrossover(0.7);
    _mutationOperator = new BitFlipMutation(0.01);
  }

  // Setters for algorithm components
  void population(IPopulation pop) {
    _population = pop;
  }

  void fitnessEvaluator(IFitnessEvaluator evaluator) {
    _fitnessEvaluator = evaluator;
  }

  void selectionStrategy(ISelectionStrategy strategy) {
    _selectionStrategy = strategy;
  }

  void crossoverOperator(ICrossoverOperator op) {
    _crossoverOperator = op;
  }

  void mutationOperator(IMutationOperator op) {
    _mutationOperator = op;
  }

  void maxGenerations(size_t max) {
    _maxGenerations = max;
  }

  void targetFitness(double target) {
    _targetFitness = target;
  }

  // Getters
  IPopulation population() {
    return _population;
  }

  size_t generation() {
    return _generation;
  }

  bool isRunning() {
    return _running;
  }

  /**
   * Initialize population with random individuals.
   */
  void initializePopulation(size_t populationSize, size_t genomeLength) {
    _population.clear();
    for (size_t i = 0; i < populationSize; i++) {
      auto genome = new ubyte[genomeLength];
      import std.random : randomShuffle;

      for (size_t j = 0; j < genomeLength; j++) {
        import std.random : uniform;

        genome[j] = cast(ubyte)uniform(0, 256);
      }
      _population.add(new Individual(genome));
    }
    _generation = 0;
  }

  /**
   * Run one generation of the genetic algorithm.
   */
  void step() {
    if (_population.size() == 0)
      return;

    // Create new population through selection, crossover, and mutation
    IIndividual[] newPopulation;

    while (newPopulation.length < _population.size()) {
      auto parent1 = _selectionStrategy.select(_population);
      auto parent2 = _selectionStrategy.select(_population);

      auto offspring = _crossoverOperator.crossover(parent1, parent2);

      foreach (child; offspring) {
        if (newPopulation.length < _population.size()) {
          _mutationOperator.mutate(child);
          newPopulation ~= child;
        }
      }
    }

    // Keep best individuals (elitism)
    _population.sort();
    if (newPopulation.length > 0) {
      auto best = _population.best();
      newPopulation[0] = best.clone();
    }

    // Replace population
    _population.clear();
    foreach (ind; newPopulation) {
      _population.add(ind);
    }

    _generation++;
  }

  /**
   * Run genetic algorithm asynchronously.
   */
  void runAsync(void delegate(bool success, IIndividual best) callback) @trusted {
    _running = true;

    void runStep() {

      void runNextGeneration() {
        if (_population.best().fitness() >= _targetFitness) {
          _running = false;
          callback(true, _population.best());
        } else {
          runStep();
        }
      }

      if (_generation >= _maxGenerations || !_running) {
        _running = false;
        _population.sort();
        auto best = _population.best();
        callback(true, best);
        return;
      }

      if (_fitnessEvaluator !is null) {
        auto individuals = _population.individuals();
        auto inds = individuals.map!(ind => cast(IIndividual)ind).array;
        _fitnessEvaluator.evaluatePopulation(inds,
          (IIndividual[] evaluated) {
          foreach (ind; evaluated) {
            // Update fitness in population
          }
          step();
          runNextGeneration();
        }
        );
      } else {
        step();
        runNextGeneration();
      }
    }

    runStep();
  }

  /**
   * Stop the algorithm.
   */
  void stop() {
    _running = false;
  }

  /**
   * Get statistics about current population.
   */
  Json statistics() {
    Json statistics = _population.statistics();
    statistics["generation"] = _generation.toJson;
    statistics["running"] = _running.toJson;
    return statistics;
  }
}
