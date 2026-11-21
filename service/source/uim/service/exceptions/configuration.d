/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.exceptions.configuration;

import uim.service;

mixin(ShowModule!());

@safe:

class UIMConfigurationException : UIMException {
  this(string message) {
    super("Configuration error: " ~ message);
  }

  this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
    super("Configuration error: " ~ message, file, line, next);
  }
}
///
unittest {
  UIMConfigurationException ex1 = new UIMConfigurationException("Test message");
  assert(ex1.message == "Configuration error: Test message");

  UIMConfigurationException ex2 = new UIMConfigurationException("Test message", "testfile.d", 123);
  assert(ex2.message == "Configuration error: Test message");
  assert(ex2.file == "testfile.d");
  assert(ex2.line == 123);
}
