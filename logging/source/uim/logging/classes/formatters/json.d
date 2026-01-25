/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.formatters.json;

import uim.logging.interfaces;
import uim.logging.enumerations.loglevel : UIMLogLevel = LogLevel, toString;
import std.datetime;
import std.json;
import std.conv;

/**
 * JSON formatter for structured log messages
 */
class DJsonFormatter : ILogFormatter {
    this() {}
    
    string format(
        UIMLogLevel level,
        string loggerName,
        string message,
        string[string] context,
        long timestamp
    ) {
        auto time = SysTime(timestamp);
        
        JSONValue json = JSONValue([
            "timestamp": JSONValue(time.toISOExtString()),
            "level": JSONValue(level.toString()),
            "logger": JSONValue(loggerName),
            "message": JSONValue(message)
        ]);
        
        // Add context fields
        if (context !is null && context.length > 0) {
            JSONValue contextJson;
            foreach (key, value; context) {
                contextJson[key] = JSONValue(value);
            }
            json["context"] = contextJson;
        }
        
        return json.toString();
    }
}
