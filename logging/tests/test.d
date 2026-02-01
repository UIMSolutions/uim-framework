/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module logging.tests.test;

import uim.logging;
import std.stdio;
import std.file;
import std.path;

/**
 * Test basic logging functionality
 */
void testBasicLogging() {
    writeln("Testing basic logging...");
    
    auto logger = ConsoleLogger("TestLogger");
    logger.info("Test message");
    logger.warning("Test warning");
    logger.error("Test error");
    
    writeln("✓ Basic logging test passed");
}

/**
 * Test log levels
 */
void testLogLevels() {
    writeln("Testing log levels...");
    
    auto logger = ConsoleLogger("LevelTest");
    logger.level = UIMLogLevel.warning;
    
    assert(logger.isEnabled(UIMLogLevel.warning));
    assert(logger.isEnabled(UIMLogLevel.error));
    assert(!logger.isEnabled(UIMLogLevel.info));
    assert(!logger.isEnabled(UIMLogLevel.debug_));
    
    writeln("✓ Log level test passed");
}

/**
 * Test file logging
 */
void testFileLogging() {
    writeln("Testing file logging...");
    
    string testFile = "test_logs/test.log";
    
    // Clean up if exists
    if (exists(testFile)) {
        remove(testFile);
    }
    
    auto logger = FileLogger(testFile, "FileTest");
    logger.info("Test file message 1");
    logger.info("Test file message 2");
    logger.close();
    
    assert(exists(testFile), "Log file should exist");
    
    // Clean up
    remove(testFile);
    if (exists("test_logs")) {
        rmdir("test_logs");
    }
    
    writeln("✓ File logging test passed");
}

/**
 * Test multi-logger
 */
void testMultiLogger() {
    writeln("Testing multi-logger...");
    
    auto multiLogger = new DMultiLogger("MultiTest");
    auto logger1 = ConsoleLogger("Logger1");
    auto logger2 = ConsoleLogger("Logger2");
    
    multiLogger.addLogger(logger1);
    multiLogger.addLogger(logger2);
    
    multiLogger.info("Multi-logger test message");
    
    assert(multiLogger.loggers().length == 2);
    
    multiLogger.removeLogger(logger1);
    assert(multiLogger.loggers().length == 1);
    
    writeln("✓ Multi-logger test passed");
}

/**
 * Test formatters
 */
void testFormatters() {
    writeln("Testing formatters...");
    
    auto textFormatter = new DTextFormatter();
    auto jsonFormatter = new DJsonFormatter();
    
    string[string] context = ["key": "value"];
    long timestamp = 0;
    
    auto textResult = textFormatter.format(
        UIMLogLevel.info, "TestLogger", "Test message", context, timestamp
    );
    assert(textResult.length > 0);
    
    auto jsonResult = jsonFormatter.format(
        UIMLogLevel.info, "TestLogger", "Test message", context, timestamp
    );
    assert(jsonResult.length > 0);
    
    writeln("✓ Formatter test passed");
}

/**
 * Test global logger
 */
void testGlobalLogger() {
    writeln("Testing global logger...");
    
    auto logger = ConsoleLogger("GlobalTest");
    globalLogger(logger);
    
    info("Global info message");
    warning("Global warning message");
    
    assert(globalLogger() is logger);
    
    writeln("✓ Global logger test passed");
}

/**
 * Run all tests
 */
void main() {
    writeln("=== Running Logging Library Tests ===\n");
    
    testBasicLogging();
    testLogLevels();
    testFileLogging();
    testMultiLogger();
    testFormatters();
    testGlobalLogger();
    
    writeln("\n=== All Tests Passed ===");
}
