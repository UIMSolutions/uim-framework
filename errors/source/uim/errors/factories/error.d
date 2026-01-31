/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.factories.error;

mixin(ShowModule!());

import uim.errors;

@safe:

class ErrorFactory : UIMFactory!(string, IError) {
  this() {
    super(() => new UIMError());
    registerCommonErrors();
  }

  // Register common error types
  private void registerCommonErrors() {
    register("InvalidArgument", () => new InvalidArgumentError());
    register("UnknownEditor", () => new UnknownEditorError());
  }

  // Register a custom error type
  override ErrorFactory register(string name, IError delegate() creator) {
    this.register(name, creator);
    return this;
  }

  // Create error with full parameters
  IError create(string name, string message, string fileName = null, size_t lineNumber = 0) {
    auto error = create(name, message);
    if (error) {
      error.fileName(fileName);
      error.lineNumber(lineNumber);
    }
    return error;
  }

  // Create error with specific type and message
  override IError create(string name, Json[string] initData = null) {
    if (auto error = super.create(name)) {
      return (error.initialize(initData)) ? error : null;
    }
    return null;
  }

  private static ErrorFactory _instance;
  static ErrorFactory instance() {
    if (_instance is null) {
      _instance = new ErrorFactory();
    }
    return _instance;
  }
}

auto errorFactory() {
  return ErrorFactory.instance();
}
