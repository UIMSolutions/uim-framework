/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.schema.result;

import uim.jsons;

mixin(ShowModule!());

@safe:

/**
 * Validation result.
 */
struct ValidationResult {
  bool valid;
  ValidationError[] errors;

  static ValidationResult success() {
    return ValidationResult(true, []);
  }

  static ValidationResult failure(ValidationError[] errs) {
    return ValidationResult(false, errs);
  }

  static ValidationResult failure(ValidationError err) {
    return ValidationResult(false, [err]);
  }
}