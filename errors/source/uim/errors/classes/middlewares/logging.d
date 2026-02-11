/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.middlewares.logging;

import uim.errors;
import std.stdio : writeln, stderr;

@safe:

/**
 * Middleware that logs errors to console or file.
 * 
 * Can log to stdout, stderr, or a custom log handler.
 * Supports filtering by severity level.
 */
class LoggingMiddleware : ErrorMiddleware {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _priority = 100; // High priority to log early

    return true;
  }

  // Minimum severity level to log (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  protected string _minSeverity = "DEBUG";

  // Whether to log to stderr instead of stdout
  protected bool _useStderr = false;

  // Custom log handler
  protected void delegate(IError) @safe _logHandler;

  // #region minSeverity
  string minSeverity() {
    return _minSeverity;
  }

  LoggingMiddleware minSeverity(string newSeverity) {
    _minSeverity = newSeverity;
    return this;
  }
  // #endregion minSeverity

  // #region useStderr
  bool useStderr() {
    return _useStderr;
  }

  LoggingMiddleware useStderr(bool newValue) {
    _useStderr = newValue;
    return this;
  }
  // #endregion useStderr

  // #region logHandler
  LoggingMiddleware logHandler(void delegate(IError) @safe handler) {
    _logHandler = handler;
    return this;
  }
  // #endregion logHandler

  override bool shouldProcess(IError error) {
    if (!_enabled) {
      return false;
    }

    // Check severity level
    return isSeverityHighEnough(error.severity());
  }

  override IError process(IError error, IError delegate(IError) @safe next) {
    if (shouldProcess(error)) {
      logError(error);
    }

    // Continue to next middleware
    return next(error);
  }

  protected bool isSeverityHighEnough(string severity) {
    string[] levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"];

    int errorLevel = -1;
    int minLevel = -1;

    foreach (i, level; levels) {
      if (level == severity)
        errorLevel = cast(int)i;
      if (level == _minSeverity)
        minLevel = cast(int)i;
    }

    if (errorLevel == -1)
      errorLevel = 0; // Default to DEBUG
    if (minLevel == -1)
      minLevel = 0;

    return errorLevel >= minLevel;
  }

  protected void logError(IError error) @trusted {
    if (_logHandler !is null) {
      _logHandler(error);
      return;
    }

    // Default console logging
    string logMessage = formatLogMessage(error);

    if (_useStderr) {
      stderr.writeln(logMessage);
    } else {
      writeln(logMessage);
    }
  }

  protected string formatLogMessage(IError error) {
    import std.format : format;
    import std.datetime : SysTime;

    string timestamp = "";
    if (error.timestamp() > 0) {
      auto time = SysTime(error.timestamp());
      timestamp = format("[%s] ", time.toISOExtString());
    }

    return format("%s[%s] %s (Code: %d) at %s:%d",
      timestamp,
      error.severity(),
      error.message(),
      error.errorCode(),
      error.fileName(),
      error.lineNumber()
    );
  }

  /**
  * Create a logging middleware with default settings.
  */
  static LoggingMiddleware opCall() {
    return new LoggingMiddleware();
  }
}
