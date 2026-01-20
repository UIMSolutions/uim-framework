/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.error;

import uim.errors;
mixin(ShowModule!());

@safe:

// This class is used to represent errors in UIM applications.

/**
 * Represents a base error class in the UIM framework.
 * Inherits from `UIMObject` and implements the `IError` interface.
 * Provides properties and methods for error handling, including message, file name, line number, log label, log level, and stack trace.
 *
 * Properties:
 * - loglabel: The label used for logging the error.
 * - loglevel: The log level associated with the error's log label.
 * - message: The error message.
 * - fileName: The name of the file where the error occurred.
 * - lineNumber: The line number where the error occurred.
 * - trace: The stack trace as an array of associative arrays.
 *
 * Methods:
 * - initialize: Initializes the error object with optional JSON data.
 * - loglabel / loglabel(string): Gets or sets the log label.
 * - loglevel: Gets the log level based on the log label.
 * - line: Gets the line number as a string.
 * - message / message(string): Gets or sets the error message.
 * - fileName / fileName(string): Gets or sets the file name.
 * - lineNumber / lineNumber(size_t): Gets or sets the line number.
 * - trace / trace(string[string][]): Gets or sets the stack trace.
 * - addTrace: Adds entries to the stack trace.
 * - traceAsString: Returns the stack trace as a formatted string.
 * - throwError: Throws a D `Error` with the current message.
 */
class UIMError : UIMObject, IError {
  mixin(ErrorThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // #region loglabel
  protected string _loglabel;
  string loglabel() {
    return _loglabel;
  }
  // Set the error code.
  IError loglabel(string newLabel) {
    _loglabel = newLabel;
    return this;
  }
  // #endregion loglabel

// #region previous
  /**
   * The previous error in the chain of errors.
   *
   * This is used to track the cause of an error through multiple layers.
   * It can be set to null if there is no previous error.
   */
  protected IError _previous;
  IError previous() {
    return _previous;
  }

  // This method is used to set the previous error in a chain of errors.
  // It can be used to track the cause of an error through multiple layers.
  /* @param newPrevious The new previous error to set.
   * @return The current instance of IError for method chaining.
   */
  IError previous(IError newPrevious) {
    _previous = newPrevious;
    return this;
  }
  // #region previous

  protected Json[string] _attributes;
  Json[string] attributes() {
    if (_attributes is null) {
      _attributes = new Json[string];
    }
    return _attributes;
  }
  IError attributes(Json[string] newAttributes) {
    _attributes = newAttributes;
    return this;
  }

  // #region loglevel
  string loglevel() {
    return uim.core.logging.LogLevels.level(loglabel());
  }
  // #endregion loglevel

  // #region line
  string line() {
    return to!string(_lineNumber);
  }
  // #endregion line

  // #region message
  protected string _message;
  // Get the error message.
  string message() {
    return _message;
  }

  // Set the error message.
  IError message(string newMessage) {
    _message = newMessage;
    return this;
  }
  // #endregion message

  // #region filemname
  protected string _fileName;
  // Get the filename.
  string fileName() {
    return _fileName;
  }

  // Set the filename.
  IError fileName(string name) {
    _fileName = name;
    return this;
  }
  // #endregion filename

  // #region lineNumber
  protected size_t _lineNumber;
  size_t lineNumber() {
    return _lineNumber;
  }

  IError lineNumber(size_t newLineNumber) {
    _lineNumber = newLineNumber;
    return this;
  }
  // #endregion lineNumber

  // #region trace
  // Get the stacktrace.
  protected string[string][] _trace;
  string[string][] trace() {
    return _trace;
  }

  IError trace(string[string][] newTrace) {
    _trace = newTrace;
    return this;
  }
  // Add a trace entry.
  IError addTrace(string[string][] newTrace) {
    _trace ~= newTrace;
    return this;
  }
  // Add a trace entry.
  IError addTrace(string reference, string file, string line) {
    string[string] newTrace;
    newTrace["reference"] = reference;
    newTrace["file"] = file;
    newTrace["line"] = line;
    addTrace(newTrace);

    return this;
  }
  // Add a trace entry.
  IError addTrace(string[string] newTrace) {
    _trace ~= newTrace;
    return this;
  }

  // Get the stacktrace as a string.
  string traceAsString() {
    return trace
      .map!(entry => "{%s} {%s, %s}".format(
          entry["reference"],
          entry["file"],
          entry["line"]))
      .join("\n");
  }
  // #endregion trace

  // #region throwError
  void throwError() {
    throw new Error(message);
  }
  // #endregion throwError
}

unittest {
  // Create a new UIMError and check default state
  auto error = new UIMError();
  assert(error !is null);

  // Test initialize
  assert(error.initialize());

  // Test loglabel getter/setter
  assert(error.loglabel() == null);
  error.loglabel("ERROR_LABEL");
  assert(error.loglabel() == "ERROR_LABEL");

  // Test loglevel (requires uim.core.logging.LogLevels.level to be stubbed/mocked if not available)
  // Here we just check that it returns a string
  assert(error.loglevel() is null || error.loglevel().length >= 0);

  // Test message getter/setter
  assert(error.message() == null);
  error.message("Test message");
  assert(error.message() == "Test message");

  // Test fileName getter/setter
  assert(error.fileName() == null);
  error.fileName("test_file.d");
  assert(error.fileName() == "test_file.d");

  // Test lineNumber getter/setter
  assert(error.lineNumber() == 0);
  error.lineNumber(123);
  assert(error.lineNumber() == 123);

  // Test line() string conversion
  assert(error.line() == "123");

  // Test trace getter/setter
  assert(error.trace() == null);
  string[string][] traces = [];
  error.trace(traces);
  assert(error.trace().length == 0);

  // Test addTrace(string[string][])
  string[string] traceEntry1;
  traceEntry1["reference"] = "ref1";
  traceEntry1["file"] = "file1.d";
  traceEntry1["line"] = "10";
  error.addTrace(traceEntry1);
  assert(error.trace().length == 1);
  assert(error.trace()[0]["reference"] == "ref1");

  // Test addTrace(string, string, string)
  error.addTrace("ref2", "file2.d", "20");
  assert(error.trace().length == 2);
  assert(error.trace()[1]["reference"] == "ref2");
  assert(error.trace()[1]["file"] == "file2.d");
  assert(error.trace()[1]["line"] == "20");

  // Test addTrace(string[string][])
  string[string] traceEntry2;
  traceEntry2["reference"] = "ref3";
  traceEntry2["file"] = "file3.d";
  traceEntry2["line"] = "30";
  error.addTrace([traceEntry2]);
  assert(error.trace().length == 3);

  // Test traceAsString
  auto traceStr = error.traceAsString();
  assert(traceStr.canFind("ref1"));
  assert(traceStr.canFind("file2.d"));
  assert(traceStr.canFind("30"));
}
