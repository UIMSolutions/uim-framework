/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.pluralize;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  Pluralizes the given English word based on common rules.
  
  Params:
      word = The singular word to pluralize.
  
  Returns:
      The pluralized form of the word.
  */
string pluralize(string word) {
  if (word.length == 0) {
    return "";
  }

  word = word.lower();
  if (word in pluralIrregulars) {
    return pluralIrregulars[word];
  }

  // 2. Rule: -s, -x, -z, -ch, -sh -> add -es
  if (word.endsWith("s") || word.endsWith("x") || word.endsWith("z") ||
    word.endsWith("ch") || word.endsWith("sh")) {
    return word ~ "es";
  }

  // 3. Rule: Consonant + y -> -ies
  if (word.endsWith("y") && word.length > 1) {
    char lastConsonant = word[word.length - 2];
    // Check if the penultimate character is not a vowel
    if (!"aeiou".canFind(lastConsonant)) {
      return word[0 .. $ - 1] ~ "ies";
    }
  }

  // 4. Default: add -s
  return word ~ "s";
}
///
unittest {
  assert(pluralize("cat") == "cats");
  assert(pluralize("bus") == "buses");
  assert(pluralize("box") == "boxes");
  assert(pluralize("church") == "churches");
  assert(pluralize("baby") == "babies");
  assert(pluralize("Person") == "people");
  assert(pluralize("person") == "people");
  assert(pluralize("Order") == "orders");
  assert(pluralize("man") == "men");
}

/**
  Pluralizes the given English word based on the count.
  
  Params:
      count = The count of items.
      singular = The singular form of the word.
  
  Returns:
      The appropriate form (singular or plural) based on the count.
  */
string pluralizeCount(int count, string singular) {
    return (count == 1) ? singular : pluralize(singular);
}
///
unittest {
  assert(pluralizeCount(1, "cat") == "cat");
  assert(pluralizeCount(2, "cat") == "cats");
  assert(pluralizeCount(1, "bus") == "bus");
  assert(pluralizeCount(3, "bus") == "buses");
} 