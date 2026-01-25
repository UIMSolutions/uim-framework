/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module logging.examples.basic;

import uim.logging;
import std.stdio;

void main() {
    writeln("=== Basic Logging Example ===\n");
    
    // Create a simple console logger
    auto logger = ConsoleLogger("BasicExample");
    
    // Log messages at different levels
    logger.trace("This is a trace message");
    logger.debug_("This is a debug message");
    logger.info("This is an info message");
    logger.warning("This is a warning message");
    logger.error("This is an error message");
    logger.critical("This is a critical message");
    logger.fatal("This is a fatal message");
    
    writeln("\n=== Logging with Context ===\n");
    
    // Log with context
    logger.info("User logged in", [
        "userId": "12345",
        "username": "john.doe",
        "ip": "192.168.1.100"
    ]);
    
    writeln("\n=== Logging with Level Filter ===\n");
    
    // Set minimum log level
    logger.level = LogLevel.warning;
    logger.info("This won't be displayed");
    logger.warning("This will be displayed");
    logger.error("This will also be displayed");
}
