/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.plist.exceptions;

import uim.core;

@safe:

/**
 * Base exception for property list operations
 */
class PlistException : UIMException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

/**
 * Exception thrown when parsing fails
 */
class PlistParseException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Parse error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown when a type conversion fails
 */
class PlistTypeException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Type error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown when a key is not found
 */
class PlistKeyException : PlistException {
    this(string key, string file = __FILE__, size_t line = __LINE__) {
        super("Key not found: " ~ key, file, line);
    }
}

/**
 * Exception thrown when validation fails
 */
class PlistValidationException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Validation error: " ~ msg, file, line);
    }
}

/**
 * Exception thrown for format-specific errors
 */
class PlistFormatException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Format error: " ~ msg, file, line);
    }
}
