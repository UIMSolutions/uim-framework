/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.exceptions;

@safe:

/**
 * Base exception for JSON-LD operations.
 */
class JSONLDException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

/**
 * Exception thrown when context processing fails.
 */
class ContextException : JSONLDException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super("Context error: " ~ msg, file, line);
  }
}

/**
 * Exception thrown when document is invalid.
 */
class InvalidDocumentException : JSONLDException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super("Invalid JSON-LD document: " ~ msg, file, line);
  }
}

/**
 * Exception thrown when expansion fails.
 */
class ExpansionException : JSONLDException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super("Expansion error: " ~ msg, file, line);
  }
}

/**
 * Exception thrown when compaction fails.
 */
class CompactionException : JSONLDException {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super("Compaction error: " ~ msg, file, line);
  }
}
