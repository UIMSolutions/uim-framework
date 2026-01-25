/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module logging.examples.formatters;

import uim.logging;
import std.stdio;

void main() {
    writeln("=== Custom Formatters Example ===\n");
    
    // Text formatter with default format
    writeln("--- Text Formatter (Default) ---");
    auto textLogger = ConsoleLogger("TextLogger");
    textLogger.info("Using default text format");
    
    // Text formatter with custom format
    writeln("\n--- Text Formatter (Custom) ---");
    auto customTextLogger = ConsoleLogger("CustomText");
    auto textFormatter = new DTextFormatter("%l | %n | %m");
    customTextLogger.formatter = textFormatter;
    customTextLogger.info("Using custom text format");
    
    // JSON formatter for structured logging
    writeln("\n--- JSON Formatter ---");
    auto jsonLogger = ConsoleLogger("JsonLogger");
    jsonLogger.formatter = new DJsonFormatter();
    jsonLogger.info("Structured log entry", [
        "userId": "12345",
        "action": "login",
        "success": "true"
    ]);
    
    // JSON formatter to file for log aggregation systems
    writeln("\n--- JSON to File ---");
    auto jsonFileLogger = FileLogger("logs/structured.json", "StructuredLogger");
    jsonFileLogger.formatter = new DJsonFormatter();
    jsonFileLogger.info("Application started", ["version": "1.0.0"]);
    jsonFileLogger.info("User action", [
        "userId": "67890",
        "action": "purchase",
        "amount": "99.99"
    ]);
    
    writeln("Structured logs written to logs/structured.json");
    
    jsonFileLogger.close();
}
