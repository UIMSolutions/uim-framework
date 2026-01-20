/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schemas.errors;

import uim.jsons;

@safe:

/**
 * Validation error.
 */
struct ValidationError {
  string keyword;    // Schema keyword that failed
  string message;    // Error message
  string path;       // Path to the property that failed

  string toString() const {
    if (path.length > 0) {
      return path ~ ": " ~ message ~ " (" ~ keyword ~ ")";
    }
    return message ~ " (" ~ keyword ~ ")";
  }
}
