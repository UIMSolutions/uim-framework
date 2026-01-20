# Error Middleware System

## Overview

The UIM error middleware system provides a flexible and powerful way to intercept, transform, filter, and process errors as they flow through your application. Middleware components can be chained together in a pipeline to create sophisticated error handling workflows.

## Core Components

### IErrorMiddleware Interface

Base interface for all error middleware:

```d
interface IErrorMiddleware {
  IError process(IError error, IError delegate(IError) @safe next);
  bool shouldProcess(IError error);
  int priority();
  IErrorMiddleware enabled(bool newEnabled);
  bool isEnabled();
}
```

### ErrorMiddleware Base Class

Abstract base class providing common functionality:

```d
class ErrorMiddleware : UIMObject, IErrorMiddleware {
  // Automatic priority and enabled state management
  // Override shouldProcess() for custom filtering
  // Override process() for middleware logic
}
```

## Built-in Middleware

### 1. LoggingMiddleware

Logs errors to console or custom handlers with severity filtering.

**Features:**
- Configurable minimum severity level
- Custom log handlers
- stderr/stdout routing
- Formatted output with timestamps

**Example:**
```d
auto logger = loggingMiddleware()
  .minSeverity("WARNING")
  .useStderr(true);

// With custom handler
logger.logHandler((IError err) @safe {
  writeln("CUSTOM: ", err.message());
});
```

### 2. FilteringMiddleware

Filters errors based on codes, severities, or custom predicates.

**Features:**
- Block specific error codes
- Whitelist allowed codes
- Block severities
- Custom filter predicates

**Example:**
```d
auto filter = filteringMiddleware()
  .addBlockedCode(404)
  .addBlockedSeverity("DEBUG")
  .allowedCodes([100, 200, 300])
  .filterPredicate((IError err) @safe {
    return err.errorCode() < 1000;
  });
```

### 3. TransformingMiddleware

Transforms errors by modifying properties or wrapping in different types.

**Features:**
- Custom transformation functions
- Conditional transformation
- Message enrichment
- Severity upgrades

**Example:**
```d
// Basic transformation
auto transformer = transformingMiddleware((IError err) @safe {
  err.message("[APP] " ~ err.message());
  err.severity("CRITICAL");
  return err;
});

// Severity upgrade
auto upgrader = severityUpgradeMiddleware("WARNING", "ERROR");
```

### 4. ErrorMiddlewarePipeline

Chains multiple middleware together with priority-based execution.

**Features:**
- Priority-based ordering
- Middleware can short-circuit pipeline
- Add/remove middleware dynamically
- Standard pipeline configurations

**Example:**
```d
auto pipeline = errorPipeline()
  .add(loggingMiddleware().priority(100))
  .add(filteringMiddleware().priority(50))
  .add(transformingMiddleware(...).priority(10));

auto result = pipeline.process(error);
```

## Usage Patterns

### Basic Usage

```d
import uim.errors;

// Create middleware
auto logger = loggingMiddleware();

// Process error
auto error = createError()
  .message("Database error")
  .errorCode(1001);

auto next = (IError err) @safe => err; // Pass-through
logger.process(error, next);
```

### Pipeline Pattern

```d
// Create pipeline
auto pipeline = errorPipeline();

// Add middleware (executed by priority, highest first)
pipeline
  .add(loggingMiddleware().priority(100))
  .add(filteringMiddleware()
    .addBlockedCode(404)
    .priority(50))
  .add(transformingMiddleware((IError err) @safe {
    err.message("Enriched: " ~ err.message());
    return err;
  }).priority(10));

// Process errors
auto result = pipeline.process(error);
```

### Standard Pipeline

```d
// Quick setup with standard middleware
auto pipeline = standardErrorPipeline();
auto result = pipeline.process(error);
```

### Custom Middleware

```d
class MyMiddleware : ErrorMiddleware {
  mixin(ObjThis!("MyMiddleware"));

  override IError process(IError error, IError delegate(IError) @safe next) {
    // Custom logic before
    error.message("Processed: " ~ error.message());
    
    // Continue chain
    auto result = next(error);
    
    // Custom logic after
    return result;
  }

  override bool shouldProcess(IError error) {
    return error.severity() == "CRITICAL";
  }
}
```

## Advanced Features

### Priority System

Middleware are executed in priority order (highest first):

```d
auto high = loggingMiddleware().priority(100);    // Executes first
auto medium = filteringMiddleware().priority(50); // Executes second
auto low = transformingMiddleware(...).priority(10); // Executes last
```

Default priorities:
- Logging: 100 (high - log early)
- Filtering: 50 (medium)
- Transforming: 25 (low - transform after logging)

### Conditional Processing

```d
auto transformer = transformingMiddleware((IError err) @safe {
  return err;
});

transformer.shouldTransform((IError err) @safe {
  return err.errorCode() >= 500; // Only transform server errors
});
```

### Error Filtering

Return `null` to filter an error and stop the pipeline:

```d
auto filter = filteringMiddleware()
  .addBlockedCode(404);

auto result = pipeline.process(error);
if (result is null) {
  // Error was filtered
}
```

### Enable/Disable Middleware

```d
auto logger = loggingMiddleware();

logger.enabled(false); // Disable temporarily
// ... later ...
logger.enabled(true);  // Re-enable
```

### Custom Log Handlers

```d
auto logger = loggingMiddleware();

logger.logHandler((IError err) @safe {
  // Write to file
  // Send to monitoring service
  // Store in database
});
```

## Real-World Examples

### Production Error Handling

```d
auto productionPipeline = errorPipeline()
  // Filter out debug errors
  .add(filteringMiddleware()
    .addBlockedSeverity("DEBUG")
    .priority(90))
  
  // Log all remaining errors
  .add(loggingMiddleware()
    .minSeverity("INFO")
    .priority(80))
  
  // Upgrade critical errors
  .add(severityUpgradeMiddleware("ERROR", "CRITICAL")
    .priority(50))
  
  // Add context
  .add(transformingMiddleware((IError err) @safe {
    err.message("[PROD] " ~ err.message());
    return err;
  }).priority(10));
```

### Development Error Handling

```d
auto devPipeline = errorPipeline()
  // Log everything
  .add(loggingMiddleware()
    .minSeverity("DEBUG")
    .useStderr(false)
    .priority(100))
  
  // Add detailed context
  .add(transformingMiddleware((IError err) @safe {
    import std.format;
    err.message(format("[DEV:%s] %s", err.fileName(), err.message()));
    return err;
  }).priority(50));
```

### Error Aggregation

```d
int[] errorCounts;

auto counter = transformingMiddleware((IError err) @safe {
  errorCounts[err.errorCode()]++;
  return err;
});

pipeline.add(counter.priority(10));
```

## Best Practices

1. **Set Appropriate Priorities**: Log early, filter in the middle, transform late
2. **Use Standard Pipeline**: Start with `standardErrorPipeline()` and customize
3. **Filter Early**: Remove unwanted errors before expensive processing
4. **Transform Late**: Modify errors after logging original state
5. **Enable/Disable**: Use enable/disable for conditional middleware
6. **Custom Handlers**: Implement custom log handlers for production systems
7. **Short-Circuit Carefully**: Return `null` only when you want to stop the pipeline

## API Reference

### Factory Functions

- `loggingMiddleware()` - Create logging middleware
- `filteringMiddleware()` - Create filtering middleware
- `transformingMiddleware(transformer)` - Create transforming middleware
- `severityUpgradeMiddleware(from, to)` - Create severity upgrade middleware
- `errorPipeline()` - Create empty pipeline
- `standardErrorPipeline()` - Create standard pipeline

### Pipeline Methods

- `add(middleware)` - Add middleware
- `addAll(middleware[])` - Add multiple middleware
- `remove(middleware)` - Remove middleware
- `clear()` - Remove all middleware
- `process(error)` - Process error through pipeline

### Middleware Methods

- `priority(int)` - Set priority
- `enabled(bool)` - Enable/disable
- `isEnabled()` - Check if enabled
- `shouldProcess(error)` - Check if should process
- `process(error, next)` - Process error

## See Also

- [Error Handling Guide](README.md)
- [Error API Documentation](../source/uim/errors/)
- [Examples](../examples/)
