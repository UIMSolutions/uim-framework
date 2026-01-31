/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.loggers.console;

import uim.logging;
@safe:

/**
 * Console logger that writes to stdout with colored output
 */
class ConsoleLogger : UIMLogger {
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
        // TODO: stdout.flush();
    }
}

/**
 * Factory function to create a console logger
 */
ConsoleLogger consoleLogger(string name = "Console") {
    return new ConsoleLogger(name);
}
