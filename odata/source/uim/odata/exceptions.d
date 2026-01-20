/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata.exceptions;

import uim.core;

@safe:

/**
 * Base exception for OData operations
 */
class ODataException : UIMException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

/**
 * Exception thrown when a query is malformed
 */
class ODataQueryException : ODataException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Query error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown when parsing fails
 */
class ODataParseException : ODataException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Parse error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown for HTTP/network errors
 */
class ODataHTTPException : ODataException {
    private int _statusCode;
    
    this(string msg, int statusCode = 0, string file = __FILE__, size_t line = __LINE__) {
        super("HTTP error: " ~ msg, file, line);
        _statusCode = statusCode;
    }
    
    @property int statusCode() const {
        return _statusCode;
    }
}

/**
 * Exception thrown for entity-related errors
 */
class ODataEntityException : ODataException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Entity error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown for filter expression errors
 */
class ODataFilterException : ODataException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Filter error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown for metadata errors
 */
class ODataMetadataException : ODataException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Metadata error: " ~ msg, file, line);
    }
}
