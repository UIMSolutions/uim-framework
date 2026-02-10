/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.tests.runners.runner;

import uim.tests;
import vibe.core.core;

mixin(ShowModule!());

@safe:

/**
 * Test runner for executing test suites
 */
class TestRunner : UIMObject {
  protected ITestSuite[] _suites;
  protected ITestReporter[] _reporters;

  this() {
    super();
  }

  void addSuite(ITestSuite suite) {
    _suites ~= suite;
  }

  void addReporter(ITestReporter reporter) {
    _reporters ~= reporter;
  }

  void run(void delegate(bool success, TestSuiteResult[] results) @safe callback) @trusted {
    TestSuiteResult[] allResults;
    size_t completed = 0;

    foreach (suite; _suites) {
      reportSuiteStart(suite);

      suite.run((bool success, TestResult[] testResults) {
        completed++;

        TestSuiteResult suiteResult = new TestSuiteResult();
        suiteResult.suiteName = suite.name();
        suiteResult.totalTests = testResults.length;

        foreach (testResult; testResults) {
          switch (testResult.result) {
            case TestResult.Passed:
              suiteResult.passedTests++;
              break;
            case TestResult.Failed:
              suiteResult.failedTests++;
              break;
            case TestResult.Skipped:
              suiteResult.skippedTests++;
              break;
            case TestResult.Error:
              suiteResult.errorTests++;
              break;
            default:
              break;
          }
          suiteResult.results ~= testResult;
        }

        reportSuiteComplete(suiteResult);
        allResults ~= suiteResult;

        if (completed == _suites.length) {
          callback(true, allResults);
        }
      });
    }

    if (_suites.length == 0) {
      callback(true, []);
    }
  }

  void runAsync(void delegate(bool success, TestSuiteResult[] results) @safe callback) @trusted {
    // Run with async support using vibe.d
    runInTask({
      run((bool success, TestSuiteResult[] results) {
        callback(success, results);
      });
    });
  }

  protected void reportSuiteStart(ITestSuite suite) {
    foreach (reporter; _reporters) {
      reporter.onSuiteStart(suite);
    }
  }

  protected void reportSuiteComplete(TestSuiteResult result) {
    foreach (reporter; _reporters) {
      reporter.onSuiteComplete(result);
    }
  }

  protected void reportTestComplete(TestCase testResult) {
    foreach (reporter; _reporters) {
      reporter.onTestComplete(testResult);
    }
  }

  string getReport() {
    if (_reporters.length == 0) return "";
    return _reporters[0].getReport();
  }

  string[string] getReports() {
    string[string] reports;
    foreach (i, reporter; _reporters) {
      string key = format("reporter_%d", i);
      reports[key] = reporter.getReport();
    }
    return reports;
  }
}

/**
 * Helper function to run tests
 */
void runTests(ITestSuite suite, void delegate(bool success, TestSuiteResult result) @safe callback) @trusted {
  auto runner = new TestRunner();
  runner.addSuite(suite);
  runner.addReporter(new ConsoleReporter());

  runner.run((bool success, TestSuiteResult[] results) {
    if (results.length > 0) {
      callback(success, results[0]);
    } else {
      callback(false, null);
    }
  });
}
