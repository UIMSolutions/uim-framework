/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.domain.enumerations.logginglevel;

import uim.services;

mixin(ShowModule!());

@safe:


// Log level
enum LoggingLevel : string {
  info = "info",
  debug_ = "debug",
  warning = "warning",
  error = "error",
  fatal = "fatal",
  trace = "trace"
}
LoggingLevel toLoggingLevel(string value) {
  switch (value.toLower()) {
    case "debug": return LoggingLevel.debug_;
    case "info": return LoggingLevel.info;
    case "warning": return LoggingLevel.warning;
    case "error": return LoggingLevel.error;
    case "fatal": return LoggingLevel.fatal;
    case "trace": return LoggingLevel.trace;
    default: return LoggingLevel.info; // default
  }
}

LoggingLevel[] toLoggingLevels(string[] values)
  => values.map!toLoggingLevel.array;

string toString(LoggingLevel level)
  => cast(string)level;

string[] toString(LoggingLevel[] levels)
  => levels.map!toString.array;
///
unittest {
  mixin(ShowTest!("LoggingLevel Enum"));

  assert(LoggingLevel.info.toString == "info");
  assert(LoggingLevel.debug_.toString == "debug");
  assert(LoggingLevel.warning.toString == "warning");
  assert(LoggingLevel.error.toString == "error");
  assert(LoggingLevel.fatal.toString == "fatal");
  assert(LoggingLevel.trace.toString == "trace");

  assert("info".toLoggingLevel == LoggingLevel.info);
  assert("debug".toLoggingLevel == LoggingLevel.debug_);
  assert("warning".toLoggingLevel == LoggingLevel.warning);
  assert("error".toLoggingLevel == LoggingLevel.error);
  assert("fatal".toLoggingLevel == LoggingLevel.fatal);
  assert("trace".toLoggingLevel == LoggingLevel.trace);

  assert("noexists".toLoggingLevel == LoggingLevel.info); // Default case
  assert("".toLoggingLevel == LoggingLevel.info); // Default case

  assert(["info", "debug", "warning", "error", "fatal", "trace"].toLoggingLevels == [LoggingLevel.info, LoggingLevel.debug_, LoggingLevel.warning, LoggingLevel.error, LoggingLevel.fatal, LoggingLevel.trace]);
  assert([LoggingLevel.info, LoggingLevel.debug_, LoggingLevel.warning, LoggingLevel.error, LoggingLevel.fatal, LoggingLevel.trace].toString == ["info", "debug", "warning", "error", "fatal", "trace"]);
}
