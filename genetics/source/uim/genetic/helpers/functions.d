/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.helpers.functions;

import uim.genetic;

mixin(ShowModule!());

@safe:

bool isSameLength(IIndividual parent1, IIndividual parent2) {
  return parent1.genomeLength() == parent2.genomeLength();
}

bool hasSameGeneSet(const(ubyte)[] genes1, const(ubyte)[] genes2) {
  if (genes1.length != genes2.length) return false;

  int[256] counts;
  foreach (gene; genes1) {
    counts[gene]++;
  }
  foreach (gene; genes2) {
    counts[gene]--;
  }
  foreach (count; counts) {
    if (count != 0) return false;
  }
  return true;
}

bool isUniquePermutation(const(ubyte)[] genes) {
  bool[256] seen;
  foreach (gene; genes) {
    if (seen[gene]) return false;
    seen[gene] = true;
  }
  return true;
}
