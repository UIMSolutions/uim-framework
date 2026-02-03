/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.logging;

import uim.oop;
@safe:

/**
 * Logging handler interface for tracking request flow.
 */
interface ILoggingHandler : IHandler {
    /**
     * Gets the log entries.
     * Returns: Array of log messages
     */
    string[] getLog() const;
    
    /**
     * Clears the log.
     */
    void clearLog();
}




