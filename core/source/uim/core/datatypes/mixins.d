/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.mixins;

import uim.core;

mixin(ShowModule!());

@safe:

// #region hasFunctions
string HasFunctions(string plural, string singular, string keyType) {
  return `
    bool hasAll{plural}({keyType}[] keys) {
      return keys.all!(key => has{singular}(key));
    }

    bool hasAny{plural}({keyType}[] keys) {
      return keys.any!(key => has{singular}(key));
    }
  `
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType);
}

template HasFunctions(string plural, string singular, string keyType) {
  const char[] HasFunctions = hasFunctions(plural, singular, keyType);
}

unittest {
  // writeln("HasFunctions ->", hasMethods("Entries", "Entry", "string"));
}
// #endregion HasFunctions
