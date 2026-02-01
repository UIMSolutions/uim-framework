/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.tests.suites.test;

import uim.tests;

mixin(ShowModule!());

@safe:

/**
 * Base test class
 */
abstract class UIMTest : UIMObject, ITest {
  protected string _name;
  protected string _description;
  protected TestCase _result;
  protected bool _isAsync = false;

  this(string testName, string testDescription = "") {
    super();
    _name = testName;
    _description = testDescription;
    _result = new TestCase();
    _result.name = testName;
    _result.description = testDescription;
  }

  string name() { return _name; }
  string description() { return _description; }
  bool isAsync() { return _isAsync; }

  void setUp() {
    // Override in subclasses
  }

  void tearDown() {
    // Override in subclasses
  }

  abstract void run();

  TestCase result() {
    return _result;
  }

  void setResult(TestResult result, string message = "") {
    _result.result = result;
    _result.message = message;
  }

  protected void pass(string message = "Test passed") {
    setResult(TestResult.Passed, message);
  }

  protected void fail(string message = "Test failed") {
    setResult(TestResult.Failed, message);
  }

  protected void skip(string message = "Test skipped") {
    setResult(TestResult.Skipped, message);
  }

  protected void error(string message = "Test error") {
    setResult(TestResult.Error, message);
  }
}

/**
 * Test suite implementation
 */
class TestSuite : UIMObject, ITestSuite {
  protected string _name;
  protected ITest[] _tests;

  this(string suiteName) {
    super();
    _name = suiteName;
  }

  string name() { return _name; }

  ITestSuite addTest(ITest test) {
    _tests ~= test;
    return this;
  }

  ITest[] tests() { return _tests.dup; }
  size_t testCount() { return _tests.length; }

  void run(void delegate(bool success, TestResult[] results) @safe callback) @trusted {
    TestResult[] results;
    
    foreach (test; _tests) {
      test.setUp();
      
      try {
        test.result().startTime = Clock.currTime();
        test.run();
        test.result().endTime = Clock.currTime();
        
        if (test.result().result == TestResult.Passed) {
          // Already set or use default
          if (test.result().message.length == 0) {
            test.setResult(TestResult.Passed);
          }
        }
      } catch (AssertionException ex) {
        test.result().endTime = Clock.currTime();
        test.setResult(TestResult.Failed, ex.msg);
      } catch (Exception ex) {
        test.result().endTime = Clock.currTime();
        test.setResult(TestResult.Error, ex.msg);
      }
      
      results ~= test.result();
      test.tearDown();
    }
    
    callback(true, results);
  }

  void runAsync(void delegate(bool success, TestResult[] results) @safe callback) @trusted {
    // Async implementation using vibe.d
    run(callback);
  }
}
