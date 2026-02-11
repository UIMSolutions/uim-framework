/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module errors.tests.middleware;

import uim.errors;
import std.stdio;

@safe:

void testBasicMiddleware() {
  writeln("Testing basic middleware functionality...");

  auto error = new UIMError();
  error.message("Test error");
  error.errorCode(100);
  error.severity("ERROR");

  IError next(IError err) { return err; }

  // Test logging middleware
  auto logger = loggingMiddleware();
  assert(logger.isEnabled());
  assert(logger.priority() == 100);
  
  auto result = logger.process(error, &next);
  assert(result !is null);
  assert(result.message() == "Test error");

  writeln("✓ Basic middleware test passed");
}

void testFilteringMiddleware() {
  writeln("Testing filtering middleware...");

  auto error = new UIMError();
  error.message("Test error");
  error.errorCode(404);
  error.severity("ERROR");

  IError next(IError err) { return err; }

  // Test code blocking
  auto filter = filteringMiddleware()
    .addBlockedCode(404);

  auto result = filter.process(error, &next);
  assert(result is null, "Error should be filtered");

  // Test code allowing
  error.errorCode(200);
  result = filter.process(error, &next);
  assert(result !is null, "Error should pass through");

  // Test severity blocking
  auto severityFilter = filteringMiddleware()
    .addBlockedSeverity("DEBUG");

  error.severity("DEBUG");
  result = severityFilter.process(error, &next);
  assert(result is null, "DEBUG error should be filtered");

  error.severity("ERROR");
  result = severityFilter.process(error, &next);
  assert(result !is null, "ERROR should pass through");

  // Test whitelist
  auto whitelist = filteringMiddleware()
    .allowedCodes([100, 200, 300]);

  error.errorCode(200);
  result = whitelist.process(error, &next);
  assert(result !is null, "Code 200 should be allowed");

  error.errorCode(404);
  result = whitelist.process(error, &next);
  assert(result is null, "Code 404 should be blocked");

  writeln("✓ Filtering middleware test passed");
}

void testTransformingMiddleware() {
  writeln("Testing transforming middleware...");

  auto error = new UIMError();
  error.message("Original message");
  error.severity("WARNING");

  IError next(IError err) { return err; }

  // Test message transformation
  auto transformer = transformingMiddleware((IError err) {
    err.message("Transformed: " ~ err.message());
    return err;
  });

  auto result = transformer.process(error, &next);
  assert(result !is null);
  assert(result.message() == "Transformed: Original message");

  // Test severity upgrade
  error.severity("INFO");
  auto upgrader = severityUpgradeMiddleware("INFO", "WARNING");
  result = upgrader.process(error, &next);
  assert(result.severity() == "WARNING");

  writeln("✓ Transforming middleware test passed");
}

void testMiddlewarePipeline() {
  writeln("Testing middleware pipeline...");

  auto pipeline = errorPipeline();

  // Add middleware in random order
  auto logger = loggingMiddleware().priority(100);
  auto filter = new FilteringMiddleware();
  filter.priority(50);
  filter.addBlockedCode(999);
  auto transformer = transformingMiddleware((IError err) {
    err.message("[PROCESSED] " ~ err.message());
    return err;
  }).priority(10);

  pipeline.add(transformer);
  pipeline.add(logger);
  pipeline.add(filter);

  assert(pipeline.middleware().length == 3);

  // Test normal processing
  {
    auto error = new UIMError();
    error.message("Test");
    error.errorCode(100);
    error.severity("ERROR");

    auto result = pipeline.process(error);
    assert(result !is null);
    assert(result.message() == "[PROCESSED] Test");
  }

  // Test filtering
  {
    auto error = new UIMError();
    error.message("Filtered");
    error.errorCode(999);
    error.severity("ERROR");
    
    auto result = pipeline.process(error);
    assert(result is null, "Error with code 999 should be filtered");
  }

  // Test pipeline clearing
  pipeline.clear();
  assert(pipeline.middleware().length == 0);

  writeln("✓ Pipeline test passed");
}

void testMiddlewarePriority() {
  writeln("Testing middleware priority ordering...");

  auto pipeline = errorPipeline();

  string[] executionOrder;

  auto mid1 = transformingMiddleware((IError err) {
    executionOrder ~= "mid1";
    return err;
  }).priority(10);

  auto mid2 = transformingMiddleware((IError err) {
    executionOrder ~= "mid2";
    return err;
  }).priority(50);

  auto mid3 = transformingMiddleware((IError err) {
    executionOrder ~= "mid3";
    return err;
  }).priority(100);

  pipeline.add(mid1);
  pipeline.add(mid2);
  pipeline.add(mid3);

  {
    auto error = new UIMError();
    error.message("Test");
    error.severity("ERROR");

    pipeline.process(error);
  }

  assert(executionOrder.length == 3);
  assert(executionOrder[0] == "mid3", "Highest priority should execute first");
  assert(executionOrder[1] == "mid2", "Medium priority should execute second");
  assert(executionOrder[2] == "mid1", "Lowest priority should execute last");

  writeln("✓ Priority ordering test passed");
}

void testMiddlewareEnableDisable() {
  writeln("Testing middleware enable/disable...");

  auto error = new UIMError();
  error.message("Test");
  error.severity("ERROR");

  IError next(IError err) { return err; }

  auto middleware = transformingMiddleware((IError err) {
    err.message("TRANSFORMED");
    return err;
  });

  // Test enabled
  auto result = middleware.process(error, &next);
  assert(result.message() == "TRANSFORMED");

  // Test disabled
  middleware.enabled(false);
  assert(!middleware.isEnabled());
  
  error.message("Test");
  result = middleware.process(error, &next);
  assert(result.message() == "Test", "Disabled middleware should not transform");

  writeln("✓ Enable/disable test passed");
}

void main() {
  writeln("\n=== Running Middleware Tests ===\n");

  testBasicMiddleware();
  testFilteringMiddleware();
  testTransformingMiddleware();
  testMiddlewarePipeline();
  testMiddlewarePriority();
  testMiddlewareEnableDisable();

  writeln("\n=== All Middleware Tests Passed ✓ ===\n");
}
