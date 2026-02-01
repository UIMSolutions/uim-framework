/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.logging.enumerations.loglevel;

@safe:
/**
 * Enumeration for logging levels
 */
enum LogLevel {
    /// Most detailed information, typically only enabled during development
    trace = 0,
    
    /// Detailed information useful for debugging
    debug_ = 1,
    
    /// General informational messages about application operation
    info = 2,
    
    /// Warning messages for potentially harmful situations
    warning = 3,
    
    /// Error events that might still allow the application to continue
    error = 4,
    
    /// Critical conditions that require immediate attention
    critical = 5,
    
    /// Severe errors that will lead to application termination
    fatal = 6,
    
    /// Disable all logging
    none = 7
}

/**
 * Convert log level to string representation
 */
string toString(LogLevel level) {
    final switch (level) {
        case LogLevel.trace: return "TRACE";
        case LogLevel.debug_: return "DEBUG";
        case LogLevel.info: return "INFO";
        case LogLevel.warning: return "WARNING";
        case LogLevel.error: return "ERROR";
        case LogLevel.critical: return "CRITICAL";
        case LogLevel.fatal: return "FATAL";
        case LogLevel.none: return "NONE";
    }
}

/**
 * Convert string to log level
 */
LogLevel toLogLevel(string level) {
    import std.string : toLower;
    
    switch (level.toLower) {
        case "trace": return LogLevel.trace;
        case "debug": return LogLevel.debug_;
        case "info": return LogLevel.info;
        case "warning": case "warn": return LogLevel.warning;
        case "error": return LogLevel.error;
        case "critical": case "crit": return LogLevel.critical;
        case "fatal": return LogLevel.fatal;
        case "none": case "off": return LogLevel.none;
        default: return LogLevel.info;
    }
}
