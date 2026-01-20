/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.exceptions.invalidargument;

import uim.errors;

mixin(ShowModule!());

@safe:

class DInvalidArgumentError : UIMError {
  mixin(ErrorThis!("InvalidArgument"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.loglabel("InvalidArgument");
    return true;
  }

  this(string errorMessage, string fileName = null, size_t lineNumber = 0) {
    super();
    _loglabel = "InvalidArgument";
    _message = errorMessage;
    if (fileName) {
      _fileName = fileName;
    }
    if (lineNumber > 0) {
      _lineNumber = lineNumber;
    }
  }
}

auto invalidArgumentError() {
  return new DInvalidArgumentError("Invalid Argument");
}

auto invalidArgumentError(string message) {
  return new DInvalidArgumentError(message);
}

auto invalidArgumentError(string message, string fileName, size_t lineNumber = 0) {
  return new DInvalidArgumentError(message, fileName, lineNumber);
}

unittest {
  auto error = invalidArgumentError();
  assert(error !is null, "Failed to create InvalidArgumentError instance");
  assert(error.message() == "Invalid Argument", "Error message mismatch");
  assert(error.loglabel() == "InvalidArgument", "Error log label mismatch");

  auto error2 = invalidArgumentError("Custom message");
  assert(error2.message() == "Custom message", "Custom error message mismatch");

  auto error3 = invalidArgumentError("File error", "test.d", 42);
  assert(error3.fileName() == "test.d", "File name mismatch");
  assert(error3.lineNumber() == 42, "Line number mismatch");
}