/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.exceptions.unknowneditor;

import uim.errors;

mixin(ShowModule!());

@safe:

class DUnknownEditorError : UIMError {
  mixin(ErrorThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.loglabel("UnknownEditor");
    return true;
  }

  this(string errorMessage = "Unknown Editor", string fileName = null, size_t lineNumber = 0) {
    super();
    initialize();
    this.message(errorMessage);
    if (fileName) {
      this.fileName(fileName);
    }
    if (lineNumber > 0) {
      this.lineNumber(lineNumber);
    }
  }
}

auto UnknownEditorError() {
  return new DUnknownEditorError("Unknown Editor");
}

auto UnknownEditorError(string message) {
  return new DUnknownEditorError(message);
}

auto UnknownEditorError(string message, string fileName, size_t lineNumber = 0) {
  return new DUnknownEditorError(message, fileName, lineNumber);
}

unittest {
  auto error = UnknownEditorError();
  assert(error !is null, "Failed to create DUnknownEditorError instance");
  assert(error.message() == "Unknown Editor", "Error message mismatch");
  assert(error.loglabel() == "UnknownEditor", "Error log label mismatch");

  auto error2 = UnknownEditorError("Custom editor error");
  assert(error2.message() == "Custom editor error", "Custom error message mismatch");

  auto error3 = UnknownEditorError("Editor not found", "editor.d", 100);
  assert(error3.fileName() == "editor.d", "File name mismatch");
  assert(error3.lineNumber() == 100, "Line number mismatch");
}