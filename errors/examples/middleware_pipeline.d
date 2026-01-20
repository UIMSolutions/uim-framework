/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.examples.middleware_pipeline;

import uim.errors;
import std.stdio;

void main() {
  writeln("=== Error Middleware Pipeline Example ===\n");

  // Create a pipeline with multiple middleware
  auto pipeline = errorPipeline();

  // Add logging middleware (will execute first due to high priority)
  auto logger = loggingMiddleware()
    .minSeverity("INFO")
    .priority(100);
  pipeline.add(logger);

  // Add filtering middleware (medium priority)
  auto filter = filteringMiddleware()
    .addBlockedSeverity("DEBUG")
    .priority(50);
  pipeline.add(filter);

  // Add transforming middleware (low priority, executes last)
  auto transformer = transformingMiddleware((IError err) @safe {
    // Add prefix to error message
    err.message("[TRANSFORMED] " ~ err.message());
    return err;
  });
  transformer.priority(10);
  pipeline.add(transformer);

  writeln("Pipeline has ", pipeline.middleware().length, " middleware\n");

  // Test 1: Process a normal error
  writeln("Test 1: Processing ERROR severity");
  auto error1 = createError()
    .message("Something went wrong")
    .errorCode(500)
    .severity("ERROR")
    .fileName(__FILE__)
    .lineNumber(__LINE__);

  auto result1 = pipeline.process(error1);
  if (result1 !is null) {
    writeln("Final message: ", result1.message());
  }

  // Test 2: Process a DEBUG error (should be filtered)
  writeln("\nTest 2: Processing DEBUG severity (should be filtered)");
  auto error2 = createError()
    .message("Debug information")
    .errorCode(100)
    .severity("DEBUG")
    .fileName(__FILE__)
    .lineNumber(__LINE__);

  auto result2 = pipeline.process(error2);
  if (result2 is null) {
    writeln("DEBUG error was filtered (as expected)");
  }

  // Test 3: Create a standard pipeline
  writeln("\n=== Standard Pipeline ===\n");
  auto standardPipeline = standardErrorPipeline();

  auto error3 = createError()
    .message("Using standard pipeline")
    .errorCode(200)
    .severity("INFO")
    .fileName(__FILE__)
    .lineNumber(__LINE__);

  standardPipeline.process(error3);

  // Test 4: Advanced pipeline with custom logic
  writeln("\n=== Advanced Pipeline ===\n");
  
  auto advancedPipeline = errorPipeline();

  // Add severity upgrade middleware
  auto upgrader = severityUpgradeMiddleware("WARNING", "ERROR");
  upgrader.priority(75);
  advancedPipeline.add(upgrader);

  // Add code-based filter
  auto codeFilter = filteringMiddleware()
    .allowedCodes([100, 200, 300]) // Only allow these codes
    .priority(80);
  advancedPipeline.add(codeFilter);

  // Add logger
  advancedPipeline.add(loggingMiddleware().priority(90));

  writeln("Testing with allowed code (200):");
  auto error4 = createError()
    .message("Allowed code")
    .errorCode(200)
    .severity("WARNING")
    .fileName(__FILE__)
    .lineNumber(__LINE__);
  
  auto result4 = advancedPipeline.process(error4);
  if (result4 !is null) {
    writeln("Severity after upgrade: ", result4.severity());
  }

  writeln("\nTesting with blocked code (500):");
  auto error5 = createError()
    .message("Blocked code")
    .errorCode(500)
    .severity("ERROR")
    .fileName(__FILE__)
    .lineNumber(__LINE__);
  
  auto result5 = advancedPipeline.process(error5);
  if (result5 is null) {
    writeln("Error with code 500 was filtered (not in allowed list)");
  }

  writeln("\n=== Pipeline Example Complete ===");
}
