module uim.oop.containers.plist.exceptions.validation;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Exception thrown when validation fails
 */
class PlistValidationException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Validation error: " ~ msg, file, line);
    }
}