/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.exceptions.authorization;

import uim.service;

mixin(ShowModule!());

@safe:

class UIMAuthorizationException : UIMException {
  this(string message) {
    super("Unauthorized: " ~ message);
  }

  this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
    super("Unauthorized: " ~ message, file, line, next);
  }
}
///
unittest {
  UIMAuthorizationException ex1 = new UIMAuthorizationException("Test message");
  assert(ex1.message == "Unauthorized: Test message");

  UIMAuthorizationException ex2 = new UIMAuthorizationException("Test message", "testfile.d", 123);
  assert(ex2.message == "Unauthorized: Test message");
  assert(ex2.file == "testfile.d");
  assert(ex2.line == 123);
}
