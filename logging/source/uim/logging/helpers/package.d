/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.helpers;

import uim.logging.interfaces;
import uim.logging.classes.loggers;
import uim.logging.enumerations.loglevel : UIMLogLevel = LogLevel;

/**
 * Global logger instance
 */
private ILogger _globalLogger;

/**
 * Get the global logger instance
 */
ILogger globalLogger() {
    if (_globalLogger is null) {
        _globalLogger = consoleLogger("Global");
    }
    return _globalLogger;
}

/**
 * Set the global logger instance
 */
void globalLogger(ILogger logger) {
    _globalLogger = logger;
}

/**
 * Convenience functions for global logging
 */
void trace(string message, string[string] context = null) {
    globalLogger().trace(message, context);
}

void debug_(string message, string[string] context = null) {
    globalLogger().debug_(message, context);
}

void info(string message, string[string] context = null) {
    globalLogger().info(message, context);
}

void warning(string message, string[string] context = null) {
    globalLogger().warning(message, context);
}

void error(string message, string[string] context = null) {
    globalLogger().error(message, context);
}

void critical(string message, string[string] context = null) {
    globalLogger().critical(message, context);
}

void fatal(string message, string[string] context = null) {
    globalLogger().fatal(message, context);
}

/**
 * Create a new logger with the specified name
 */
ILogger createLogger(string name, UIMLogLevel level = UIMLogLevel.info) {
    auto logger = consoleLogger(name);
    logger.level = level;
    return logger;
}

/**
 * Create a file logger
 */
ILogger createFileLogger(string filename, string name = "File", UIMLogLevel level = UIMLogLevel.info) {
    auto logger = fileLogger(filename, name);
    logger.level = level;
    return logger;
}

/**
 * Create a multi-logger that logs to both console and file
 */
ILogger multiLogger(string filename, string name = "Multi", UIMLogLevel level = UIMLogLevel.info) {
    auto multiLogger = new MultiLogger(name);
    multiLogger.addLogger(consoleLogger(name ~ ".Console"));
    multiLogger.addLogger(fileLogger(filename, name ~ ".File"));
    multiLogger.level = level;
    return multiLogger;
}
