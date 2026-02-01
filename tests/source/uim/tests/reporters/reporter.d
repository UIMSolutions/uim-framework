/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.tests.reporters.reporter;

import uim.tests;
import std.format : format;

mixin(ShowModule!());

@safe:

/**
 * Console test reporter
 */
class ConsoleReporter : UIMObject, ITestReporter {
  protected string[] _output;
  protected SysTime _suiteStartTime;

  void onTestStart(ITest test) {
    _output ~= format("  ► %s", test.name());
  }

  void onTestComplete(TestCase result) {
    string status = result.isPassed() ? "✓" : 
                   result.isFailed() ? "✗" : 
                   result.isSkipped() ? "⊘" : "!";
    
    string line = format("    %s %s (%.2fms)", status, result.name, result.duration());
    
    if (result.message.length > 0) {
      line ~= format(" - %s", result.message);
    }
    
    _output ~= line;
  }

  void onSuiteStart(ITestSuite suite) {
    _suiteStartTime = Clock.currTime();
    _output ~= format("\n%s:", suite.name());
  }

  void onSuiteComplete(TestSuiteResult result) {
    double suiteDuration = (Clock.currTime() - _suiteStartTime).total!"msecs" / 1000.0;
    
    _output ~= "";
    _output ~= format("  Results: %d/%d passed (%.1f%%) in %.2fs",
      result.passedTests, result.totalTests, result.passRate(), suiteDuration);
    
    if (result.failedTests > 0) {
      _output ~= format("  Failed: %d", result.failedTests);
    }
    if (result.errorTests > 0) {
      _output ~= format("  Errors: %d", result.errorTests);
    }
    if (result.skippedTests > 0) {
      _output ~= format("  Skipped: %d", result.skippedTests);
    }
  }

  string getReport() {
    return _output.join("\n");
  }
}

/**
 * Json test reporter
 */
class JsonReporter : UIMObject, ITestReporter {
  protected Json _report;
  protected string _currentSuite;

  this() {
    super();
    _report = Json.emptyObject();
    _report["suites"] = Json.emptyArray();
  }

  void onTestStart(ITest test) {
    // Tracked in onTestComplete
  }

  void onTestComplete(TestCase result) {
    if (_currentSuite.length > 0) {
      auto suite = _report["suites"][_report["suites"].length - 1];
      
      Json testResult = Json.emptyObject();
      testResult["name"] = Json(result.name);
      testResult["description"] = Json(result.description);
      testResult["result"] = Json(result.result.to!string);
      testResult["message"] = Json(result.message);
      testResult["duration"] = Json(result.duration());
      
      suite["tests"] ~= testResult;
    }
  }

  void onSuiteStart(ITestSuite suite) {
    _currentSuite = suite.name();
    
    Json suiteObj = Json.emptyObject();
    suiteObj["name"] = Json(suite.name());
    suiteObj["tests"] = Json.emptyArray();
    
    _report["suites"] ~= suiteObj;
  }

  void onSuiteComplete(TestSuiteResult result) {
    auto suite = _report["suites"][_report["suites"].length - 1];
    
    suite["totalTests"] = Json(result.totalTests);
    suite["passedTests"] = Json(result.passedTests);
    suite["failedTests"] = Json(result.failedTests);
    suite["skippedTests"] = Json(result.skippedTests);
    suite["errorTests"] = Json(result.errorTests);
    suite["passRate"] = Json(result.passRate());
  }

  string getReport() {
    return _report.toPrettyString();
  }
}

/**
 * TAP (Test Anything Protocol) reporter
 */
class TAPReporter : UIMObject, ITestReporter {
  protected string[] _output;
  protected size_t _testCount = 0;
  protected size_t _passCount = 0;

  void onTestStart(ITest test) {
    // TAP doesn't track start, only complete
  }

  void onTestComplete(TestCase result) {
    _testCount++;
    
    if (result.isPassed()) {
      _passCount++;
      _output ~= format("ok %d - %s", _testCount, result.name);
    } else if (result.isSkipped()) {
      _output ~= format("ok %d - %s # SKIP", _testCount, result.name);
    } else {
      _output ~= format("not ok %d - %s", _testCount, result.name);
      if (result.message.length > 0) {
        _output ~= format("  ---");
        _output ~= format("  message: '%s'", result.message);
        _output ~= format("  ...");
      }
    }
  }

  void onSuiteStart(ITestSuite suite) {
    _output ~= format("# %s", suite.name());
  }

  void onSuiteComplete(TestSuiteResult result) {
    // TAP header
    _output = format("1..%d", result.totalTests) ~ _output;
  }

  string getReport() {
    return _output.join("\n");
  }
}
