/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.containers.plist.exceptions.parse;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Exception thrown when parsing fails
 */
class PlistParseException : PlistException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super("Parse error: " ~ msg, file, line);
    }
}