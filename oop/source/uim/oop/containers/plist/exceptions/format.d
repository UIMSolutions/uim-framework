/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.containers.plist.exceptions.format;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Exception thrown for format-specific errors
 */
class PlistFormatException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Format error: " ~ msg, file, line);
    }
}
