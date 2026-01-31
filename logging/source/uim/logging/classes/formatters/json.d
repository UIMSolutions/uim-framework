/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.formatters.json;

import uim.logging;
@safe:
/**
 * Json formatter for structured log messages
 */
class JsonFormatter : ILogFormatter {
    this() {}
    
    string format(
        UIMLogLevel level,
        string loggerName,
        string message,
        string[string] context,
        long timestamp
    ) {
        auto time = SysTime(timestamp);
        
        Json json = [
            "timestamp": Json(time.toISOExtString()),
            "level": Json(level.toString()),
            "logger": Json(loggerName),
            "message": Json(message)
        ].toJson;
        
        // Add context fields
        if (context !is null && context.length > 0) {
            Json contextJson = Json.emptyObject;
            foreach (key, value; context) {
                contextJson[key] = Json(value);
            }
            json["context"] = contextJson;
        }
        
        return json.toString();
    }
}
