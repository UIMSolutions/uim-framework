/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module logging.examples.multi_logging;

import uim.logging;
import std.stdio;

void main() {
    writeln("=== Multi-Logger Example ===\n");
    
    // Create a multi-logger that logs to multiple destinations
    auto multiLogger = new DMultiLogger("Application");
    
    // Add console logger
    auto consoleLogger = ConsoleLogger("Console");
    multiLogger.addLogger(consoleLogger);
    
    // Add file logger
    auto fileLogger = FileLogger("logs/app.log", "File");
    multiLogger.addLogger(fileLogger);
    
    // Now all messages go to both console and file
    multiLogger.info("Application initialized");
    multiLogger.info("Connected to database", ["host": "localhost", "port": "5432"]);
    multiLogger.warning("Cache is 80% full");
    multiLogger.error("Request timeout");
    
    writeln("\nLogs written to both console and logs/app.log");
    
    // Helper function for creating multi-logger
    auto quickMultiLogger = createMultiLogger("logs/quick.log", "Quick");
    quickMultiLogger.info("This is even easier!");
    
    // Cleanup
    multiLogger.close();
    quickMultiLogger.close();
}
