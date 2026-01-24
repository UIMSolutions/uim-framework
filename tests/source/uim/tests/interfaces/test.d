/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.tests.interfaces.test;

import uim.tests;

mixin(ShowModule!());

@safe:

/**
 * Test result enumeration
 */
enum TestResult {
  Passed,
  Failed,
  Skipped,
  Error
}

/**
 * Single test result with details
 */
class TestCase {
  string name;
  string description;
  TestResult result;
  string message;
  SysTime startTime;
  SysTime endTime;
  
  double duration() {
    if (endTime > startTime) {
      return (endTime - startTime).total!"msecs" / 1000.0;
    }
    return 0.0;
  }
  
  bool isPassed() { return result == TestResult.Passed; }
  bool isFailed() { return result == TestResult.Failed; }
  bool isSkipped() { return result == TestResult.Skipped; }
  bool hasError() { return result == TestResult.Error; }
}

/**
 * Test interface for defining test contracts
 */
interface ITest {
  /**
   * Get test name
   */
  string name();

  /**
   * Get test description
   */
  string description();

  /**
   * Run setup before test
   */
  void setUp();

  /**
   * Run the test
   */
  void run();

  /**
   * Run teardown after test
   */
  void tearDown();

  /**
   * Check if test is async
   */
  bool isAsync();

  /**
   * Get test result
   */
  TestCase result();

  /**
   * Set test result
   */
  void setResult(TestResult result, string message = "");
}
