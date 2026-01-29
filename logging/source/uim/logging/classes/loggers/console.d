/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.loggers.console;

import uim.logging.classes.loggers.base;
import std.stdio;

/**
 * Console logger that writes to stdout with colored output
 */
class ConsoleLogger : DLogger {
    private {
        bool _useColors = true;
    }
    
    this(string loggerName = "Console") {
        super(loggerName);
    }
    
    @property bool useColors() { return _useColors; }
    @property void useColors(bool value) { _useColors = value; }
    
    protected override void writeLog(string formattedMessage) {
        // Use vibe.d's logging for colored console output
        if (_useColors) {
            writeln(formattedMessage);
        } else {
            writeln(formattedMessage);
        }
        stdout.flush();
    }
}

/**
 * Factory function to create a console logger
 */
DConsoleLogger ConsoleLogger(string name = "Console") {
    return new DConsoleLogger(name);
}
