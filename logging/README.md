# UIM Logging Library

A comprehensive logging library for the UIM framework built with D language and vibe.d.

## Features

- Multiple log levels (Trace, Debug, Info, Warning, Error, Critical, Fatal)
- Flexible logging interface with multiple implementations
- File-based logging with rotation support
- Console logging with colored output
- Structured logging with context and metadata
- Async logging support via vibe.d
- Thread-safe logging operations
- Customizable log formatters
- Log filtering and level control

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-framework:logging" version="~>1.0.0"
```

Or to your `dub.json`:

```json
"dependencies": {
    "uim-framework:logging": "~>1.0.0"
}
```

## Quick Start

```d
import uim.logging;

// Create a simple logger
auto logger = new DLogger("MyApp");

// Log messages at different levels
logger.trace("Detailed trace information");
logger.debug_("Debug information");
logger.info("General information");
logger.warning("Warning message");
logger.error("Error occurred");
logger.critical("Critical issue");
logger.fatal("Fatal error");

// Log with context
logger.info("User logged in", ["userId": "12345", "ip": "127.0.0.1"]);
```

## Usage Examples

### Console Logger

```d
auto logger = ConsoleLogger();
logger.info("Starting application");
```

### File Logger

```d
auto logger = FileLogger("app.log");
logger.info("Application started");
```

### Multi-Logger (Log to multiple destinations)

```d
auto multiLogger = new DMultiLogger();
multiLogger.addLogger(ConsoleLogger());
multiLogger.addLogger(FileLogger("app.log"));
multiLogger.info("This goes to both console and file");
```

### Custom Log Formatting

```d
auto logger = new DLogger("MyApp");
logger.setFormatter(new JsonLogFormatter());
logger.info("Structured log entry");
```

## Log Levels

- **TRACE**: Most detailed information, typically only enabled during development
- **DEBUG**: Detailed information useful for debugging
- **INFO**: General informational messages
- **WARNING**: Warning messages for potentially harmful situations
- **ERROR**: Error events that might still allow the application to continue
- **CRITICAL**: Critical conditions that require immediate attention
- **FATAL**: Severe errors that will lead to application termination

## Configuration

Configure logging behavior:

```d
auto logger = new DLogger("MyApp");
logger.setLevel(LogLevel.INFO); // Only log INFO and above
logger.setFormat("%t [%l] %n: %m"); // Custom format
```

## Architecture

The library follows UIM framework patterns:

- **Interfaces**: Define contracts for loggers and formatters
- **Classes**: Concrete implementations (DLogger, ConsoleLogger, FileLogger)
- **Mixins**: Reusable logging functionality
- **Factories**: Create logger instances

## License

Apache License 2.0

## Author

Ozan Nurettin Süel (aka UIManufaktur)

Copyright © 2018-2026
