/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.mixins.logger;

/**
 * Mixin template to add logging capabilities to any class
 */
mixin template TLogger() {
    import uim.logging;
    
    private ILogger _logger;
    
    @property ILogger logger() {
        if (_logger is null) {
            _logger = ConsoleLogger(typeid(this).name);
        }
        return _logger;
    }
    
    @property void logger(ILogger value) {
        _logger = value;
    }
    
    // Convenience methods
    protected void logTrace(string message, string[string] context = null) {
        logger.trace(message, context);
    }
    
    protected void logDebug(string message, string[string] context = null) {
        logger.debug_(message, context);
    }
    
    protected void logInfo(string message, string[string] context = null) {
        logger.info(message, context);
    }
    
    protected void logWarning(string message, string[string] context = null) {
        logger.warning(message, context);
    }
    
    protected void logError(string message, string[string] context = null) {
        logger.error(message, context);
    }
    
    protected void logCritical(string message, string[string] context = null) {
        logger.critical(message, context);
    }
    
    protected void logFatal(string message, string[string] context = null) {
        logger.fatal(message, context);
    }
}
