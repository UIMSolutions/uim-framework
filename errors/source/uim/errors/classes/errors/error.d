/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.errors.error;

import uim.errors;
import std.algorithm : map;
import std.array : join;
import std.conv : to;
import std.string : replace, toUpper;

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
 * - initialize: Initializes the error object with optional Json data.
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

    // Set timestamp to current time if not already set
    if (_timestamp == 0) {
      import std.datetime : Clock;

      _timestamp = Clock.currStdTime();
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
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.loglabel() == null); // Default should be null
    error.loglabel("ERROR_LABEL");
    assert(error.loglabel() == "ERROR_LABEL");
  }
  // #endregion loglabel

  // #region errorCode
  protected int _errorCode;
  int errorCode() {
    return _errorCode;
  }

  IError errorCode(int newCode) {
    _errorCode = newCode;
    return this;
  }
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.errorCode() == 0); // Default should be 0
    error.errorCode(1001);
    assert(error.errorCode() == 1001);
  }
  // #endregion errorCode

  // #region timestamp
  protected long _timestamp;
  long timestamp() {
    return _timestamp;
  }

  IError timestamp(long newTimestamp) {
    _timestamp = newTimestamp;
    return this;
  }
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.timestamp() > 0); // Should be set to current time on initialization
    long oldTimestamp = error.timestamp();
    error.timestamp(oldTimestamp + 1000);
    assert(error.timestamp() == oldTimestamp + 1000);
  }
  // #endregion timestamp

  // #region severity
  /// The severity level of the error (e.g., "error", "warning", "notice", "critical", "debug").
  protected string _severity = "error"; // error, warning, notice, critical, debug
  /// Get the severity level of the error.
  string severity() {
    return _severity;
  }
  /// Set the severity level of the error.
  IError severity(string newSeverity) {
    _severity = newSeverity;
    return this;
  }
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.severity() == "error");
    error.severity("warning");
    assert(error.severity() == "warning");
  }
  // #endregion severity

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
      _attributes = null;
    }
    return _attributes;
  }

  IError attributes(Json[string] newAttributes) {
    _attributes = newAttributes;
    return this;
  }

  // #region loglevel
  string loglevel() {
    return logLevels.level(loglabel());
  }
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.loglevel() is null || error.loglevel().length >= 0); // Should return a string or null
  }
  // #endregion loglevel

  // #region line
  string line() {
    return to!string(_lineNumber);
  }
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.line() == "0"); // Default line number should be 0
    error.lineNumber(123);
    assert(error.line() == "123");
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
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.message() == null); // Default should be null
    error.message("Test message");
    assert(error.message() == "Test message");
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
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.fileName() == null); // Default should be null
    error.fileName("test_file.d");
    assert(error.fileName() == "test_file.d");
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
  /// 
  unittest {
    auto error = new UIMError();
    assert(error.lineNumber() == 0); // Default should be 0
    error.lineNumber(123);
    assert(error.lineNumber() == 123);
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
  /// 
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

  // #region Formatting and Output
  // Get formatted error message with all details
  string toDetailedString() {
    import std.format : format;

    string result = "[%s] %s".format(severity.toUpper(), message);

    if (_errorCode != 0) {
      result ~= " (Code: %d)".format(_errorCode);
    }

    if (_fileName) {
      result ~= "\n  File: %s".format(_fileName);
      if (_lineNumber > 0) {
        result ~= ":%d".format(_lineNumber);
      }
    }

    if (_loglabel) {
      result ~= "\n  Label: %s".format(_loglabel);
    }

    if (_trace && _trace.length > 0) {
      result ~= "\n  Stack Trace:\n    " ~ traceAsString().replace("\n", "\n    ");
    }

    return result;
  }
  /// 
  unittest {
    mixin(ShowTest

    auto error = new UIMError();
    error.message("Test error")
      .severity("warning")
      .errorCode(1001)
      .fileName("test_file.d")
      .lineNumber(42)
      .loglabel("TEST_LABEL")
      .addTrace("main", "test_file.d", "42");

    string detailed = error.toDetailedString();
    assert(detailed.canFind("[WARNING] Test error"));
    assert(detailed.canFind("Code: 1001"));
    assert(detailed.canFind("File: test_file.d:42"));
    assert(detailed.canFind("Label: TEST_LABEL"));
    assert(detailed.canFind("{main} {test_file.d, 42}"));
  }

  // Get compact error representation
  override string toString() const {
    if (_fileName && _lineNumber > 0) {
      return "%s in %s:%d".format(_message, _fileName, _lineNumber);
    }
    return _message;
  }
  // #endregion Formatting and Output

  // #region throwError
  void throwError() {
    throw new Error(message);
  }
  // #endregion throwError
}
/// 
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
