module uim.oop.containers.plist.exceptions.type;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Exception thrown when a type conversion fails
 */
class PlistTypeException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Type error: " ~ msg, file, line);
    }
}