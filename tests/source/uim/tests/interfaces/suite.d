/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.tests.interfaces.suite;

import uim.tests;

mixin(ShowModule!());

@safe:

/**
 * Test suite interface
 */
interface ITestSuite {
  /**
   * Get suite name
   */
  string name();

  /**
   * Add a test to the suite
   */
  ITestSuite addTest(ITest test);

  /**
   * Get all tests in suite
   */
  ITest[] tests();

  /**
   * Get number of tests
   */
  size_t testCount();

  /**
   * Run the test suite
   */
  void run(void delegate(bool success, TestResult[] results) @safe callback) @trusted;

  /**
   * Run with async support
   */
  void runAsync(void delegate(bool success, TestResult[] results) @safe callback) @trusted;
}

/**
 * Test reporter interface
 */
interface ITestReporter {
  /**
   * Report test start
   */
  void onTestStart(ITest test);

  /**
   * Report test complete
   */
  void onTestComplete(TestCase result);

  /**
   * Report suite start
   */
  void onSuiteStart(ITestSuite suite);

  /**
   * Report suite complete
   */
  void onSuiteComplete(TestSuiteResult result);

  /**
   * Get formatted report
   */
  string getReport();
}

/**
 * Test suite result
 */
class TestSuiteResult {
  string suiteName;
  size_t totalTests;
  size_t passedTests;
  size_t failedTests;
  size_t skippedTests;
  size_t errorTests;
  TestCase[] results;
  double duration;
  
  double passRate() {
    if (totalTests == 0) return 0.0;
    return (cast(double)passedTests / cast(double)totalTests) * 100.0;
  }
}
