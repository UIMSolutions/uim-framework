/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.loggers.base;

import uim.logging;
import std.datetime;

/**
 * Base logger class providing common functionality
 */
abstract class DLogger : ILogger {
    protected {
        string _name;
        LogLevel _level = LogLevel.info;
        ILogFormatter _formatter;
    }
    
    this(string loggerName = "Default") {
        _name = loggerName;
        _formatter = new DTextFormatter();
    }
    
    // Properties
    @property string name() { return _name; }
    @property void name(string value) { _name = value; }
    
    @property LogLevel level() { return _level; }
    @property void level(LogLevel value) { _level = value; }
    
    @property ILogFormatter formatter() { return _formatter; }
    @property void formatter(ILogFormatter value) { _formatter = value; }
    
    // Core logging method - must be implemented by subclasses
    abstract protected void writeLog(string formattedMessage);
    
    // Main log method
    void log(LogLevel level, string message, string[string] context = null) {
        if (!isEnabled(level)) {
            return;
        }
        
        auto timestamp = Clock.currStdTime();
        auto formatted = _formatter.format(level, _name, message, context, timestamp);
        writeLog(formatted);
    }
    
    // Convenience methods
    void trace(string message, string[string] context = null) {
        log(LogLevel.trace, message, context);
    }
    
    void debug_(string message, string[string] context = null) {
        log(LogLevel.debug_, message, context);
    }
    
    void info(string message, string[string] context = null) {
        log(LogLevel.info, message, context);
    }
    
    void warning(string message, string[string] context = null) {
        log(LogLevel.warning, message, context);
    }
    
    void error(string message, string[string] context = null) {
        log(LogLevel.error, message, context);
    }
    
    void critical(string message, string[string] context = null) {
        log(LogLevel.critical, message, context);
    }
    
    void fatal(string message, string[string] context = null) {
        log(LogLevel.fatal, message, context);
    }
    
    // Check if a level is enabled
    bool isEnabled(LogLevel level) {
        return level >= _level;
    }
    
    // Default implementations - can be overridden
    void flush() {
        // Default: do nothing
    }
    
    void close() {
        flush();
    }
}
