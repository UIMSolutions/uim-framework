module oop.exceptions;

  this(string message) {
    super("Configuration error: " ~ message);
  }

  this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
    super("Configuration error: " ~ message, file, line, next);
  }
