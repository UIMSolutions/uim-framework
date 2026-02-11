/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.examples.middleware_basic;

import uim.errors;
import std.stdio;

void main() {
  writeln("=== Basic Middleware Example ===\n");

  // Create an error
  auto error = createError()
    .message("Database connection failed")
    .errorCode(1001)
    .severity("ERROR")
    .fileName(__FILE__)
    .lineNumber(__LINE__);

  // Create a simple logging middleware
  auto logger = loggingMiddleware()
    .minSeverity("WARNING");

  writeln("Processing error through logging middleware:");
  auto next = (IError err) @safe => err; // Simple pass-through
  auto result = logger.process(error, next);

  writeln("\n=== Middleware with Custom Handler ===\n");

  // Create logging middleware with custom handler
  auto customLogger = loggingMiddleware();
  customLogger.logHandler((IError err) {
    import std.stdio : writeln;
    writeln("CUSTOM LOG: ", err.message(), " [", err.severity(), "]");
  });

  customLogger.process(error, next);

  writeln("\n=== Filtering Middleware ===\n");

  // Create a filtering middleware
  auto filter = filteringMiddleware()
    .addBlockedCode(1001); // Block code 1001

  writeln("Filtering error with code 1001:");
  result = filter.process(error, next);
  if (result is null) {
    writeln("Error was filtered out (as expected)");
  }

  // Try with different code
  error.errorCode(2001);
  writeln("\nProcessing error with code 2001:");
  result = filter.process(error, next);
  if (result !is null) {
    writeln("Error passed through filter");
  }

  writeln("\n=== Transforming Middleware ===\n");

  // Create a transforming middleware that upgrades severity
  auto transformer = transformingMiddleware((IError err) {
    writeln("Transforming: ", err.severity(), " -> CRITICAL");
    err.severity("CRITICAL");
    return err;
  });

  error.severity("WARNING");
  writeln("Original severity: ", error.severity());
  result = transformer.process(error, next);
  writeln("After transformation: ", result.severity());

  writeln("\n=== Example Complete ===");
}
