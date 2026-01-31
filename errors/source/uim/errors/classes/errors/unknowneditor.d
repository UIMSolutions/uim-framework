/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.unknowneditor;

import uim.errors;

mixin(ShowModule!());

@safe:

class UnknownEditorError : UIMError {
  mixin(ErrorThis!("UnknownEditor"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.loglabel("UnknownEditor");

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
/** 
  * Creates and returns a new UnknownEditorError instance with default message.
  */
auto unknownEditorError() {
  Json[string] initData;
  initData["message"] = "Unknown Editor";
  return new UnknownEditorError(initData);
}

/** 
  * Creates and returns a new UnknownEditorError instance with specified message.
  */
auto unknownEditorError(string message) {
  Json[string] initData;
  initData["message"] = message;
  return new UnknownEditorError(initData);
}

/** 
  * Creates and returns a new UnknownEditorError instance with specified message, file name and line number.
  */
auto unknownEditorError(string message, string fileName, size_t lineNumber = 0) {
  Json[string] initData;
  initData["message"] = message;
  initData["fileName"] = fileName;
  initData["lineNumber"] = lineNumber;
  return new UnknownEditorError(initData);
}
/// 
unittest {
  auto error = unknownEditorError();
  assert(error !is null, "Failed to create UnknownEditorError instance");
  assert(error.message() == "Unknown Editor", "Error message mismatch");
  assert(error.loglabel() == "UnknownEditor", "Error log label mismatch");

  auto error2 = unknownEditorError("Custom editor error");
  assert(error2.message() == "Custom editor error", "Custom error message mismatch");

  auto error3 = unknownEditorError("Editor not found", "editor.d", 100);
  assert(error3.fileName() == "editor.d", "File name mismatch");
  assert(error3.lineNumber() == 100, "Line number mismatch");
}