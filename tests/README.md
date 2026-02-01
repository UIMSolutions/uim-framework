# UIM Tests - Unit Testing Framework

Updated on 1. February 2026


A comprehensive, async-friendly unit testing framework for D language built on vibe.d. Provides fluent assertions, multiple report formats, and seamless integration with the UIM ecosystem.

## Overview

UIM Tests is a modern unit testing framework designed for D language, offering intuitive assertions, flexible test organization, and multiple output formats (Console, Json, TAP). It's built on top of the UIM framework and leverages vibe.d for async/await support.

## Key Features

### Core Capabilities
- **Fluent Assertions**: Intuitive assertion syntax with method chaining
- **Test Suites**: Organize tests into logical groups
- **Setup/Teardown**: Lifecycle hooks for test initialization and cleanup
- **Multiple Reporters**: Console, Json, and TAP (Test Anything Protocol) output formats
- **Type Safety**: Strong compile-time type checking for assertions
- **Async Support**: Native vibe.d integration for async test execution

### Assertion Types
- **Equality**: `assertEquals`, `assertNotEquals`
- **Boolean**: `assertTrue`, `assertFalse`
- **Null Checks**: `assertNull`, `assertNotNull`
- **Comparisons**: `assertGreaterThan`, `assertLessThan`
- **String Operations**: `assertStringContains`
- **Array Operations**: `assertArrayContains`
- **Exception Handling**: `assertThrows`
- **Fluent Matchers**: `expect()` for chaining assertions

### Test Results
- **Passed**: Test assertions all succeeded
- **Failed**: Test assertion failed
- **Skipped**: Test marked as skipped
- **Error**: Unexpected exception during test execution

## Installation

Add the dependency to your `dub.sdl`:

```d
dependency "uim-tests" version="*"
```

## Quick Start

### Define a Test Suite

```d
import uim.tests;

class MathTests : TestSuite {
    this() {
        super("Math Tests");
        
        // Add individual tests
        addTest(new AdditionTest());
        addTest(new SubtractionTest());
    }
}

class AdditionTest : UIMTest {
    this() {
        super("Addition Test", "Test basic addition");
    }
    
    override void run() {
        Assert.assertEquals(2 + 2, 4);
        Assert.assertEquals(5 + 3, 8);
        pass("Addition test passed");
    }
}

class SubtractionTest : UIMTest {
    this() {
        super("Subtraction Test", "Test basic subtraction");
    }
    
    override void run() {
        Assert.assertEquals(10 - 5, 5);
        Assert.assertEquals(20 - 3, 17);
    }
}
```

### Run Tests

```d
void main() {
    auto suite = new MathTests();
    
    auto runner = new TestRunner();
    runner.addSuite(suite);
    runner.addReporter(new ConsoleReporter());
    
    runner.run((bool success, TestSuiteResult[] results) {
        if (success) {
            writeln("All tests passed!");
        } else {
            writeln("Some tests failed");
        }
    });
}
```

## Assertions

### Static Assertions

```d
// Equality
Assert.assertEquals(5, 5);
Assert.assertNotEquals(5, 3);

// Boolean
Assert.assertTrue(2 + 2 == 4);
Assert.assertFalse(2 + 2 == 5);

// Null checks
Assert.assertNull(nullValue);
Assert.assertNotNull(nonNullValue);

// Comparisons
Assert.assertGreaterThan(10, 5);
Assert.assertLessThan(3, 10);

// Strings
Assert.assertStringContains("hello world", "world");

// Arrays
Assert.assertArrayContains([1, 2, 3], 2);

// Exceptions
Assert.assertThrows!Exception(() {
    throw new Exception("error");
});

// Fail test
Assert.fail("Test failed for reason X");
```

### Fluent Assertions

```d
expect(5).equal(5);
expect(value).notEqual(3);
expect(ptr).notNull();
expect(nullPtr).isNull();
```

## Test Suites

### Basic Suite Structure

```d
class UserTests : TestSuite {
    this() {
        super("User Tests");
        addTest(new UserCreationTest());
        addTest(new UserValidationTest());
    }
}
```

### Test Lifecycle

```d
class MyTest : UIMTest {
    private int setupCount = 0;
    
    this() {
        super("My Test");
    }
    
    override void setUp() {
        // Run before test
        setupCount = 1;
    }
    
    override void run() {
        Assert.assertEquals(setupCount, 1);
    }
    
    override void tearDown() {
        // Run after test
        // Cleanup code here
    }
}
```

## Reporters

### Console Reporter

Default human-readable output:

```
Math Tests:
  ► Addition Test
    ✓ Addition Test (0.5ms) - Addition test passed
  ► Subtraction Test
    ✓ Subtraction Test (0.3ms)

  Results: 2/2 passed (100.0%) in 0.80s
```

### Json Reporter

Machine-readable Json format:

```d
auto runner = new TestRunner();
runner.addReporter(new JsonReporter());

string jsonReport = runner.getReport();
// Returns structured Json with all test results
```

### TAP Reporter

Test Anything Protocol format for CI/CD integration:

```
1..2
# Math Tests
ok 1 - Addition Test
ok 2 - Subtraction Test
```

## Test Results

Each test returns a `TestCase` result with:
- **name**: Test name
- **description**: Test description
- **result**: TestResult enum (Passed, Failed, Skipped, Error)
- **message**: Result message
- **duration()**: Execution time in seconds

## Async Testing

All test execution is async-friendly with vibe.d:

```d
auto runner = new TestRunner();
runner.addSuite(suite);

// Run synchronously
runner.run((bool success, TestSuiteResult[] results) {
    // Handle results
});

// Run asynchronously with vibe.d
runner.runAsync((bool success, TestSuiteResult[] results) {
    // Handle results in async context
});
```

## Module Structure

```
uim.tests
├── uim.tests.interfaces     # Test and suite contracts
│   ├── test.d               # ITest, TestCase, TestResult
│   └── suite.d              # ITestSuite, ITestReporter
├── uim.tests.assertions     # Assertion helpers
│   └── assertion.d          # Assert class, matchers
├── uim.tests.suites         # Test implementations
│   └── test.d               # UIMTest, TestSuite
├── uim.tests.runners        # Test execution
│   └── runner.d             # TestRunner
├── uim.tests.reporters      # Result formatting
│   └── reporter.d           # ConsoleReporter, JsonReporter, TAPReporter
└── uim.tests.helpers        # Utilities
```

## Usage Examples

### Example 1: Calculator Tests

```d
class CalculatorTests : TestSuite {
    this() {
        super("Calculator Tests");
        addTest(new AddTest());
        addTest(new MultiplyTest());
    }
}

class AddTest : UIMTest {
    this() { super("Add Test"); }
    
    override void run() {
        auto calc = new Calculator();
        Assert.assertEquals(calc.add(2, 3), 5);
        Assert.assertEquals(calc.add(-1, 1), 0);
    }
}

class MultiplyTest : UIMTest {
    this() { super("Multiply Test"); }
    
    override void run() {
        auto calc = new Calculator();
        Assert.assertEquals(calc.multiply(3, 4), 12);
        Assert.assertEquals(calc.multiply(0, 100), 0);
    }
}
```

### Example 2: String Validation Tests

```d
class StringValidationTests : TestSuite {
    this() {
        super("String Validation");
        addTest(new EmailValidationTest());
        addTest(new PasswordValidationTest());
    }
}

class EmailValidationTest : UIMTest {
    this() { super("Email Validation"); }
    
    override void run() {
        auto validator = new EmailValidator();
        
        Assert.assertTrue(validator.isValid("test@example.com"));
        Assert.assertFalse(validator.isValid("invalid.email"));
        Assert.assertStringContains("test@example.com", "@");
    }
}
```

### Example 3: Exception Testing

```d
class ExceptionTests : TestSuite {
    this() {
        super("Exception Tests");
        addTest(new DivisionByZeroTest());
    }
}

class DivisionByZeroTest : UIMTest {
    this() { super("Division by Zero"); }
    
    override void run() {
        Assert.assertThrows!ArithmeticException(() {
            divide(10, 0);
        }, "Division by zero should throw");
    }
}
```

## Integration with CI/CD

### TAP Output for CI

```d
auto tapReporter = new TAPReporter();
runner.addReporter(tapReporter);

// Output suitable for CI/CD tools that parse TAP
string tapOutput = runner.getReport();
```

### Json Output for Reporting

```d
auto jsonReporter = new JsonReporter();
runner.addReporter(jsonReporter);

// Machine-readable format for dashboards and reports
string jsonReport = runner.getReport();
```

## Design Patterns

### 1. **Fluent Builder Pattern**
   - Test suites built with method chaining
   - Assertion matchers use fluent interface

### 2. **Callback-Based Execution**
   - Async-first design using callbacks
   - Compatible with vibe.d event loop

### 3. **Reporter Pattern**
   - Pluggable reporters for different output formats
   - Decouple test execution from reporting

### 4. **Template Method Pattern**
   - `UIMTest` base class with setUp/run/tearDown hooks
   - Tests override run() for custom behavior

## Performance Considerations

1. **Fast Execution**: Minimal overhead for assertions
2. **Lazy Evaluation**: Assertions only evaluate what's needed
3. **Memory Efficient**: Stream-based reporter output
4. **Async Operations**: Non-blocking test execution with vibe.d

## Thread Safety

Framework is async-safe with vibe.d's task system. For multi-threaded testing:
- Use separate test contexts per thread
- Synchronize shared test resources
- Leverage vibe.d's fiber-based concurrency

## Dependencies

- **uim-core**: Core framework utilities
- **uim-oop**: Object-oriented patterns
- **vibe-d**: Async I/O framework (v0.9.6+)

## Future Enhancements

Planned features:
- Parameterized tests (data-driven testing)
- Test filtering and selective execution
- Parallel test execution
- Code coverage integration
- Mock/stub framework integration
- Assertion type matchers (Greater, Less, In, Matches, etc.)
