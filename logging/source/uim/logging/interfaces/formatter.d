/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.interfaces.formatter;

import uim.logging;
@safe:
/**
 * Interface for log formatters
 */
interface ILogFormatter {
    /**
     * Format a log entry into a string
     * 
     * Params:
     *   level = The log level
     *   loggerName = Name of the logger
     *   message = The log message
     *   context = Additional context data
     *   timestamp = Time of the log entry
     * 
     * Returns: Formatted log string
     */
    string format(
        UIMLogLevel level,
        string loggerName,
        string message,
        string[string] context,
        long timestamp
    );
}
