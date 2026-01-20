/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.singularize;

import uim.core;

mixin(ShowModule!());

@safe:



string singularize(string word) {
  if (word.length <= 1)
    return word;

  // 1. Irregular Nouns Mapping

  word = word.lower();
  if (word in singularIrregulars)
    return singularIrregulars[word];

  // 2. Rule: -ies -> -y (e.g., "parties" -> "party")
  if (word.endsWith("ies")) {
    return word[0 .. $ - 3] ~ "y";
  }

  // 3. Rule: -es for s, x, z, ch, sh (e.g., "boxes" -> "box")
  // We check for these specific endings to avoid ruining words like "apples"
  string[] esEndings = ["ses", "xes", "zes", "ches", "shes"];
  foreach (suffix; esEndings) {
    if (word.endsWith(suffix)) {
      return word[0 .. $ - 2]; // Remove "es"
    }
  }

  // 4. Default Rule: Remove trailing -s (e.g., "apples" -> "apple")
  if (word.endsWith("s") && !word.endsWith("ss")) {
    return word[0 .. $ - 1];
  }

  return word;
}
/// 
unittest {
  assert(singularize("people") == "person");
  assert(singularize("men") == "man");
}
