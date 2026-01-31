/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.formatters.text;

import uim.logging;
@safe:
/**
 * Text formatter for log messages
 */
class TextFormatter : ILogFormatter {
    private {
        string _format = "%t [%l] %n: %m";
        string _dateFormat = "yyyy-MM-dd HH:mm:ss";
    }
    
    this() {}
    
    this(string formatString) {
        _format = formatString;
    }
    
    @property string formatString() { return _format; }
    @property void formatString(string value) { _format = value; }
    
    @property string dateFormat() { return _dateFormat; }
    @property void dateFormat(string value) { _dateFormat = value; }
    
    string format(
        UIMLogLevel level,
        string loggerName,
        string message,
        string[string] context,
        long timestamp
    ) {
        auto time = SysTime(timestamp);
        auto result = _format;
        
        // Replace placeholders
        import std.array : replace;
        result = result.replace("%t", time.toSimpleString()[0..19]); // Timestamp
        result = result.replace("%l", level.toString()); // Log level
        result = result.replace("%n", loggerName); // Logger name
        result = result.replace("%m", message); // Message
        
        // Add context if available
        if (context !is null && context.length > 0) {
            string contextStr = " {";
            bool first = true;
            import std.format : format;
            foreach (key, value; context) {
                if (!first) contextStr ~= ", ";
                contextStr ~= format("%s: \"%s\"", key, value);
                first = false;
            }
            contextStr ~= "}";
            result ~= contextStr;
        }
        
        return result;
    }
}
