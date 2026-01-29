/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.invalidargument;

import uim.errors;

mixin(ShowModule!());

@safe:

class alidArgumentError : UIMError {
  mixin(ErrorThis!("InvalidArgument"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.loglabel("InvalidArgument");

    if (initData.hasKey("message")) {
      _message = initData["message"].get!string;
    }

    if (initData.hasKey("fileName")) {
      _fileName = initData["fileName"].get!string;
    }
    if (initData.hasKey("lineNumber")) {
      _lineNumber = initData["lineNumber"].get!size_t;
    }
    return true;
  }
}

auto invalidArgumentError() {
  Json[string] initData;
  initData["message"] = "Invalid Argument";
  return new DInvalidArgumentError(initData);
}

auto invalidArgumentError(string message) {
  Json[string] initData;
  initData["message"] = message;
  return new DInvalidArgumentError(initData);
}

auto invalidArgumentError(string message, string fileName, size_t lineNumber = 0) {
  Json[string] initData;
  initData["message"] = message;
  initData["fileName"] = fileName;
  initData["lineNumber"] = lineNumber;
  return new DInvalidArgumentError(initData);
}
///
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