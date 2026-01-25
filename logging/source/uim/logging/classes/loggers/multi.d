/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.loggers.multi;

import uim.logging;

/**
 * Multi-logger that dispatches to multiple loggers
 */
class DMultiLogger : DLogger {
    private {
        ILogger[] _loggers;
    }
    
    this(string loggerName = "Multi") {
        super(loggerName);
    }
    
    /**
     * Add a logger to the multi-logger
     */
    void addLogger(ILogger logger) {
        _loggers ~= logger;
    }
    
    /**
     * Remove a logger from the multi-logger
     */
    void removeLogger(ILogger logger) {
        import std.algorithm : remove;
        
        foreach (i, l; _loggers) {
            if (l is logger) {
                _loggers = _loggers.remove(i);
                break;
            }
        }
    }
    
    /**
     * Get all loggers
     */
    ILogger[] loggers() {
        return _loggers.dup;
    }
    
    /**
     * Clear all loggers
     */
    void clearLoggers() {
        _loggers = [];
    }
    
    protected override void writeLog(string formattedMessage) {
        // This won't be called directly, we override log instead
    }
    
    // Override log to dispatch to all loggers
    override void log(LogLevel level, string message, string[string] context = null) {
        if (!isEnabled(level)) {
            return;
        }
        
        foreach (logger; _loggers) {
            logger.log(level, message, context);
        }
    }
    
    override void flush() {
        foreach (logger; _loggers) {
            logger.flush();
        }
    }
    
    override void close() {
        foreach (logger; _loggers) {
            logger.close();
        }
    }
}
