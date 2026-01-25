/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.interfaces.logger;

import uim.logging;

/**
 * Interface for all logger implementations
 */
interface ILogger {
    // Properties
    @property string name();
    @property void name(string value);
    
    @property LogLevel level();
    @property void level(LogLevel value);
    
    // Core logging methods
    void log(LogLevel level, string message, string[string] context = null);
    
    // Convenience methods for each log level
    void trace(string message, string[string] context = null);
    void debug_(string message, string[string] context = null);
    void info(string message, string[string] context = null);
    void warning(string message, string[string] context = null);
    void error(string message, string[string] context = null);
    void critical(string message, string[string] context = null);
    void fatal(string message, string[string] context = null);
    
    // Check if a log level is enabled
    bool isEnabled(LogLevel level);
    
    // Flush any buffered log entries
    void flush();
    
    // Close and cleanup resources
    void close();
}
