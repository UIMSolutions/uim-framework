/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.genetic.helpers.functions;

import uim.genetic;

mixin(ShowModule!());

@safe:

/**
    * Helper functions for genetic algorithms
    *
    * This module provides utility functions for working with genetic algorithms, such as checking genome lengths,
    * comparing gene sets, and verifying unique permutations of genes.
    */
bool isSameLength(IIndividual parent1, IIndividual parent2) {
  return parent1.genomeLength() == parent2.genomeLength();
}

/**
    * Checks if two gene sets contain the same genes, regardless of order.
    *
    * Parameters:
    * - genes1: The first gene set
    * - genes2: The second gene set
    *
    * Returns: true if both gene sets contain the same genes, false otherwise
    */
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
