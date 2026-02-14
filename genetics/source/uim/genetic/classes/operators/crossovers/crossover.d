/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.classes.operators.crossovers.crossover;

import uim.genetic;
import uim.genetic.classes.operators.crossovers.arithmetic;
import uim.genetic.classes.operators.crossovers.kpoint;
import uim.genetic.classes.operators.crossovers.ox;
import uim.genetic.classes.operators.crossovers.permutation;
import uim.genetic.classes.operators.crossovers.pmx;
import uim.genetic.classes.operators.crossovers.single;
import uim.genetic.classes.operators.crossovers.twopint;
import uim.genetic.classes.operators.crossovers.uniform;

mixin(ShowModule!());

@safe:


class CrossoverFactory {
  static ICrossoverOperator create(string type, double rate = 0.7) {
    final lcType = type.toLower();
    if (lcType == "single") {
      return new SinglePointCrossover(rate);
    } else if (lcType == "two-point" || lcType == "twopoint") {
      return new TwoPointCrossover(rate);
    } else if (lcType == "k-point" || lcType == "kpoint" || lcType == "k-punkt" || lcType == "kpunkt") {
      return new KPunktCrossover(rate);
    } else if (lcType == "uniform" || lcType == "uniformer") {
      return new UniformCrossover(rate);
    } else if (lcType == "arithmetic") {
      return new ArithmeticCrossover(rate);
    } else if (lcType == "pmx") {
      return new PMXCrossover(rate);
    } else if (lcType == "ox") {
      return new OXCrossover(rate);
    } else if (lcType == "permutation" || lcType == "permutations" || lcType == "cycle") {
      return new PermutationCrossover(rate);
    } else {
      throw new ArgumentException("Unknown crossover type: " ~ type);
    }
  }
}
