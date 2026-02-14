module uim.genetic.classes.tourment;

import uim.genetic;

mixin(ShowModule!());

@safe:

class TournamentSelection : ISelectionStrategy {
  protected size_t _tournamentSize = 3;

  this() {
  }

  this(size_t size) {
    _tournamentSize = size;
  }

  override IIndividual select(IPopulation population) {
    if (population.size() == 0) return null;

    IIndividual best = null;
    for (size_t i = 0; i < _tournamentSize && i < population.size(); i++) {
      auto candidate = population.get(uniform(0, population.size()));
      if (best is null || candidate.fitness() > best.fitness()) {
        best = candidate;
      }
    }
    return best;
  }

  override IIndividual[] selectMultiple(IPopulation population, size_t count) {
    IIndividual[] selected;
    for (size_t i = 0; i < count; i++) {
      selected ~= select(population);
    }
    return selected;
  }
}
