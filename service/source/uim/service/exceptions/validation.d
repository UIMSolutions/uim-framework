/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.exceptions.validation;

import uim.service;

mixin(ShowModule!());

@safe:
class UIMValidationException : UIMException {
  this(string message) {
    super("Validation error: " ~ message);
  }

  this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
    super("Validation error: " ~ message, file, line, next);
  }
}
///
unittest {
  UIMValidationException ex1 = new UIMValidationException("Test message");
  assert(ex1.message == "Validation error: Test message");

  UIMValidationException ex2 = new UIMValidationException("Test message", "testfile.d", 123);
  assert(ex2.message == "Validation error: Test message");
  assert(ex2.file == "testfile.d");
  assert(ex2.line == 123);
}
