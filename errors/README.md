# UIM Errors Module

Updated on 1. February 2026


The UIM Errors module provides a comprehensive error handling system for D applications built with the UIM framework.

## Features

- **Structured Error Classes**: Object-oriented error handling with rich metadata
- **Error Chaining**: Track error causes through multiple layers with `previous()` 
- **Stack Traces**: Built-in stack trace support with formatted output
- **Error Factory**: Centralized error creation with type registration
- **Severity Levels**: Categorize errors by severity (error, warning, notice, critical, debug)
- **Error Codes**: Numeric error codes for programmatic handling
- **Timestamps**: Automatic timestamping of errors
- **Formatters & Renderers**: Multiple output formats (console, HTML, Json, XML, YAML)
- **Type Safety**: Strongly typed error classes instead of exceptions

## Core Components

### UIMError Class

The base error class with comprehensive metadata:

```d
auto error = new UIMError();
error.message("Database connection failed")
     .fileName("app.d")
     .lineNumber(42)
     .errorCode(1001)
     .severity("critical")
     .loglabel("DatabaseError");

// Add stack trace
error.addTrace("connectDB", "database.d", "105");
error.addTrace("initApp", "app.d", "42");

// Get formatted output
writeln(error.toDetailedString());
```

### Error Factory

Create errors efficiently using the factory pattern:

```d
// Get factory instance
auto factory = errorFactory();

// Create error by type
auto error = factory.create("InvalidArgument", "Value must be positive");

// Register custom error types
factory.register("CustomError", () => new MyCustomError());

// Create with full parameters
auto error2 = factory.create("UnknownEditor", "Editor not found", "editor.d", 100);
```

### Predefined Error Types

#### InvalidArgumentError
```d
auto error = invalidArgumentError("Invalid input parameter");
auto error2 = invalidArgumentError("Negative value", "validation.d", 55);
```

#### UnknownEditorError
```d
auto error = unknownEditorError("VSCode plugin not found");
auto error3 = unknownEditorError("Unknown editor type", "plugin.d", 200);
```

## Error Properties

| Property | Type | Description |
|----------|------|-------------|
| `message` | string | Error message |
| `fileName` | string | Source file where error occurred |
| `lineNumber` | size_t | Line number in source file |
| `errorCode` | int | Numeric error code |
| `severity` | string | Severity level (error, warning, notice, critical, debug) |
| `loglabel` | string | Label for logging system |
| `timestamp` | long | Timestamp when error was created |
| `trace` | string[string][] | Stack trace entries |
| `previous` | IError | Previous error in chain |
| `attributes` | Json[string] | Additional custom attributes |

## Error Formatting

### Detailed Output
```d
auto error = invalidArgumentError("Value out of range");
error.errorCode(400).severity("error");
writeln(error.toDetailedString());
// [ERROR] Value out of range (Code: 400)
//   Label: InvalidArgument
```

### Compact Output
```d
writeln(error.toString());
// Value out of range in validation.d:55
```

### Stack Trace
```d
writeln(error.traceAsString());
// {connectDB} {database.d, 105}
// {initApp} {app.d, 42}
```

## Error Renderers

Multiple renderers for different output formats:

- **ConsoleRenderer**: Terminal output
- **HTMLRenderer**: HTML formatted errors
- **JsonRenderer**: Json structured errors
- **XMLRenderer**: XML formatted errors
- **YAMLRenderer**: YAML formatted errors
- **TextRenderer**: Plain text output
- **WebRenderer**: Web-friendly error pages

## Error Enumerations

Use predefined error level constants:

```d
import uim.errors.enumerations.errors : ERRORS;

if (errorLevel & ERRORS.ERROR) {
    // Handle fatal error
}
if (errorLevel & ERRORS.WARNING) {
    // Handle warning
}
```

Available levels:
- `ERROR`, `WARNING`, `NOTICE`, `PARSE`
- `CORE_ERROR`, `CORE_WARNING`
- `COMPILER_ERROR`, `COMPILER_WARNING`
- `USER_ERROR`, `USER_WARNING`, `USER_NOTICE`
- `STRICT`, `RECOVERABLE_ERROR`, `DEPRECATED`, `USER_DEPRECATED`

## Best Practices

1. **Use Specific Error Types**: Create custom error classes for different error scenarios
2. **Chain Errors**: Use `previous()` to maintain error context across layers
3. **Add Context**: Include file names, line numbers, and stack traces
4. **Set Severity**: Use appropriate severity levels for filtering and logging
5. **Use Error Codes**: Assign unique codes for programmatic error handling
6. **Log Systematically**: Use loglabel for consistent logging categorization

## Creating Custom Errors

```d
class MyCustomError : UIMError {
  mixin(ErrorThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    this.loglabel("CustomError");
    this.severity("critical");
    return true;
  }

  this(string errorMessage = "Custom error occurred") {
    super();
    _loglabel = "CustomError";
    _message = errorMessage;
    _severity = "critical";
  }
}

// Factory function
auto myCustomError(string message = "Custom error occurred") {
  return new MyCustomError(message);
}

// Register with factory
errorFactory().register("CustomError", () => new MyCustomError());
```

## Migration from Exceptions

The module has transitioned from D Exceptions to error classes for better control and structure:

**Before:**
```d
throw new InvalidArgumentException("Bad input");
```

**After:**
```d
throw invalidArgumentError("Bad input").throwError();
// Or create without throwing
auto error = invalidArgumentError("Bad input");
handleError(error);
```

## License

Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.

## Authors

Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
