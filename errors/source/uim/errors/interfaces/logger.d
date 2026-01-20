/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.interfaces.logger;

import uim.errors;
mixin(ShowModule!());
@safe:

// Used by the ErrorHandlerMiddleware and global error handlers to log errors and errors.
interface IErrorLogger {
    // Log an error for an error with optional request context.
    /* void logError(
        Throwable error,
        IServerRequest currentRequest = null,
        bool anIncludeTrace = false
    );

    // Log an error to uim`s Log subsystem
    void logError(
        IError errorToLog,
        IServerRequest serverRequest = null,
        bool shouldLogIncludeTrace = false
    ); */
}
