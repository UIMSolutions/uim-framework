/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module logging.examples.file_logging;

import uim.logging;
import std.stdio;

void main() {
    writeln("=== File Logging Example ===\n");
    
    // Create a file logger
    auto logger = FileLogger("logs/application.log", "FileExample");
    
    // Log some messages
    logger.info("Application started");
    logger.info("Processing request", ["requestId": "REQ-001"]);
    logger.warning("High memory usage detected");
    logger.error("Failed to connect to database");
    
    writeln("Logs written to logs/application.log");
    
    // Create a logger with custom settings
    auto customLogger = FileLogger("logs/custom.log", "CustomLogger");
    customLogger.maxFileSize = 5 * 1024 * 1024; // 5 MB
    customLogger.autoRotate = true;
    
    customLogger.info("This logger will rotate files when they exceed 5 MB");
    
    // Don't forget to close when done
    logger.close();
    customLogger.close();
    
    writeln("Loggers closed successfully");
}
