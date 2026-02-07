module uim.oop.containers.plist.exceptions.key;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Exception thrown when a key is not found
 */
class PlistKeyException : PlistException {
    this(string key, string file = __FILE__, size_t line = __LINE__) {
        super("Key not found: " ~ key, file, line);
    }
}
