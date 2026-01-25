/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module logging.examples.global_logger;

import uim.logging;
import std.stdio;

void main() {
    writeln("=== Global Logger Example ===\n");
    
    // Configure global logger
    auto fileLogger = FileLogger("logs/global.log", "Global");
    globalLogger(fileLogger);
    
    // Use global logging functions from anywhere
    info("Application started");
    debug_("Initializing modules");
    warning("Configuration file not found, using defaults");
    
    // Call a function that uses global logging
    processRequest("REQ-12345");
    
    // Change global logger at runtime
    auto multiLogger = createMultiLogger("logs/multi-global.log", "GlobalMulti");
    globalLogger(multiLogger);
    
    info("Switched to multi-logger");
    processRequest("REQ-67890");
    
    globalLogger().close();
}

void processRequest(string requestId) {
    info("Processing request", ["requestId": requestId]);
    debug_("Validating request data");
    info("Request processed successfully");
}
