/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.mutation;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
 * Bit-flip mutation operator.
 */
class BitFlipMutation : IMutationOperator {
  protected double _rate = 0.01;

  this() {
  }

  this(double rate) {
    _rate = rate;
  }

  override void mutate(IIndividual individual) {
    auto genome = individual.genome().dup;
    
    foreach (ref gene; genome) {
      for (int bit = 0; bit < 8; bit++) {
        if (uniform(0.0, 1.0) < _rate) {
          gene ^= cast(ubyte)(1 << bit);
        }
      }
    }
    
    individual.genome(genome);
  }

  override double rate() {
    return _rate;
  }

  override void rate(double value) {
    _rate = value;
  }
}

/**
 * Gaussian mutation operator for real-valued genes.
 */
class GaussianMutation : IMutationOperator {
  protected double _rate = 0.1;
  protected double _sigma = 0.1;

  this() {
  }

  this(double rate, double sigma) {
    _rate = rate;
    _sigma = sigma;
  }

  override void mutate(IIndividual individual) {
    auto genome = individual.genome().dup;

    foreach (ref gene; genome) {
      if (uniform(0.0, 1.0) < _rate) {
        // Simple Gaussian-like mutation by adding random noise
        import std.math : pow;
        double noise = uniform(-1.0, 1.0) * _sigma;
        double geneValue = cast(double)gene / 255.0;
        geneValue += noise;
        geneValue = geneValue < 0 ? 0 : (geneValue > 1 ? 1 : geneValue);
        gene = cast(ubyte)(geneValue * 255.0);
      }
    }

    individual.genome(genome);
  }

  override double rate() {
    return _rate;
  }

  override void rate(double value) {
    _rate = value;
  }
}

/**
 * Swap mutation operator.
 */
class SwapMutation : IMutationOperator {
  protected double _rate = 0.05;

  this() {
  }

  this(double rate) {
    _rate = rate;
  }

  override void mutate(IIndividual individual) {
    auto genome = individual.genome().dup;

    if (genome.length < 2) return;

    if (uniform(0.0, 1.0) < _rate) {
      size_t i = uniform(0, genome.length);
      size_t j = uniform(0, genome.length);
      
      auto temp = genome[i];
      genome[i] = genome[j];
      genome[j] = temp;
    }

    individual.genome(genome);
  }

  override double rate() {
    return _rate;
  }

  override void rate(double value) {
    _rate = value;
  }
}
